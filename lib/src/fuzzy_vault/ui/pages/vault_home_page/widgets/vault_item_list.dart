import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

class VaultItemList extends StatelessWidget {
  const VaultItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultSearchCubit, VaultSearchState>(
      builder: (context, searchState) {
        if (searchState.query.isNotEmpty) {
          if (searchState.status == StateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (searchState.results.isEmpty) {
            return const Center(child: Text('No results found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: searchState.results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return VaultItemCard(itemMetadata: searchState.results[index]);
            },
          );
        }

        return BlocBuilder<VaultItemsCubit, VaultItemsState>(
          builder: (context, itemsState) {
            if (itemsState.status == StateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            var items = itemsState.items;
            if (itemsState.selectedGroupId != null) {
              items = items.where((i) => i.groupId == itemsState.selectedGroupId).toList();
            }

            if (items.isEmpty) {
              return const Center(child: Text('Vault is empty. Add a password or note.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return VaultItemCard(itemMetadata: items[index]);
              },
            );
          },
        );
      },
    );
  }
}

class VaultItemCard extends StatelessWidget {
  final VaultItemMetadata itemMetadata;

  const VaultItemCard({super.key, required this.itemMetadata});

  @override
  Widget build(BuildContext context) {
    final isPassword = itemMetadata.type == VaultItemType.password;
    final icon = isPassword ? Icons.key_rounded : Icons.notes_rounded;
    final title = itemMetadata.title;

    return Container(
      decoration: BoxDecoration(
        color: context.uiColors.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: context.uiColors.primaryColor),
        title: Text(
          title,
          style: TextStyle(
            color: context.uiColors.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isPassword ? 'Password' : 'Note',
          style: TextStyle(color: context.uiColors.secondaryTextColor),
        ),
        trailing: IconButton(
          icon: Icon(Icons.copy, color: context.uiColors.secondaryTextColor),
          onPressed: () {
            // Need to fetch full item and decrypt to copy. For now just placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copying not fully implemented yet.')),
            );
          },
        ),
        onTap: () async {
          // Fetch the full item using the repository, then pass to editor
          final masterKey = context.read<VaultAuthCubit>().state.masterKey;
          if (masterKey == null) return;
          
          final repo = sl.get<VaultRepository>();
          final res = await repo.getItem(itemMetadata.id, masterKey);
          
          if (res is VaultSuccess && context.mounted) {
            await context.push(
              AppRouter.vaultItemEditor,
              extra: VaultItemEditorPagePayload(
                type: itemMetadata.type,
                existingItem: (res as VaultSuccess<VaultItem>).data,
              ),
            );
            if (context.mounted) await context.read<VaultItemsCubit>().loadItems();
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load item')),
            );
          }
        },
      ),
    );
  }
}
