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

class _VaultHomePageState extends State<VaultHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = sl.get<PreferencesService>().vaultLastSelectedTabIndex;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex.clamp(0, 2),
    );
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VaultItemsCubit>().loadItems();
      context.read<VaultGroupsCubit>().loadGroups();
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    sl
        .get<PreferencesService>()
        .setVaultLastSelectedTabIndex(_tabController.index);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  VaultItemType get _activeType {
    if (_tabController.index == 0) return VaultItemType.password;
    if (_tabController.index == 1) return VaultItemType.note;
    return VaultItemType.file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VaultSearchBar(),
          _VaultTabBar(controller: _tabController),
          const VaultGroupFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                VaultItemList(filterType: VaultItemType.password),
                VaultItemList(filterType: VaultItemType.note),
                VaultItemList(filterType: VaultItemType.file),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createItem(context),
        backgroundColor: context.uiColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _createItem(BuildContext context) async {
    await context.push(
      AppRouter.vaultItemEditor,
      extra: VaultItemEditorPagePayload(type: _activeType),
    );
    if (context.mounted) await context.read<VaultItemsCubit>().loadItems();
  }
}

class _VaultTabBar extends StatelessWidget {
  final TabController controller;

  const _VaultTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: BoxDecoration(
        color: context.uiColors.backgroundSecondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: context.uiColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: context.uiColors.backgroundPrimaryColor,
        unselectedLabelColor: context.uiColors.secondaryTextColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
        splashBorderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.all(4),
        tabs: [
          Tab(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.key_rounded, size: 16),
                const SizedBox(width: 6),
                Text(currentContextLocalization.vaultPasswords),
              ],
            ),
          ),
          Tab(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notes_rounded, size: 16),
                const SizedBox(width: 6),
                Text(currentContextLocalization.vaultNotes),
              ],
            ),
          ),
          Tab(
            height: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.file_present_rounded, size: 16),
                const SizedBox(width: 6),
                Text(currentContextLocalization.vaultFiles),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
