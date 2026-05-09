import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

export 'widgets/vault_group_filter.dart';
export 'widgets/vault_item_list.dart';
export 'widgets/vault_search_bar.dart';
export 'widgets/widgets.dart';

class VaultHomePage extends StatefulWidget {
  const VaultHomePage({super.key});

  @override
  State<VaultHomePage> createState() => _VaultHomePageState();
}

class _VaultHomePageState extends State<VaultHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VaultItemsCubit>().loadItems();
      context.read<VaultGroupsCubit>().loadGroups();
    });
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.uiColors.secondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                'Add to Vault',
                style: TextStyle(
                  color: context.uiColors.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.key, color: context.uiColors.primaryColor),
                title: Text('New Password', style: TextStyle(color: context.uiColors.primaryTextColor)),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  await context.push(
                    AppRouter.vaultItemEditor,
                    extra: const VaultItemEditorPagePayload(type: VaultItemType.password),
                  );
                  if (context.mounted) await context.read<VaultItemsCubit>().loadItems();
                },
              ),
              ListTile(
                leading: Icon(Icons.notes, color: context.uiColors.primaryColor),
                title: Text('New Secure Note', style: TextStyle(color: context.uiColors.primaryTextColor)),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  await context.push(
                    AppRouter.vaultItemEditor,
                    extra: const VaultItemEditorPagePayload(type: VaultItemType.note),
                  );
                  if (context.mounted) await context.read<VaultItemsCubit>().loadItems();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by MainShellPage
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VaultSearchBar(),
          VaultGroupFilter(),
          Expanded(child: VaultItemList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        backgroundColor: context.uiColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
