import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class VaultGroupFilter extends StatelessWidget {
  const VaultGroupFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultGroupsCubit, VaultGroupsState>(
      builder: (context, groupsState) {
        return BlocBuilder<VaultItemsCubit, VaultItemsState>(
          builder: (context, itemsState) {
            final selectedGroupId = itemsState.selectedGroupId;

            return SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _GroupChip(
                    title: 'All',
                    isSelected: selectedGroupId == null,
                    onTap: () => context.read<VaultItemsCubit>().filterByGroup(null),
                  ),
                  const SizedBox(width: 8),
                  ...groupsState.groups.map((g) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _GroupChip(
                        title: g.name,
                        icon: _getIconForGroup(g.name),
                        isSelected: selectedGroupId == g.id,
                        onTap: () => context.read<VaultItemsCubit>().filterByGroup(g.id),
                      ),
                    );
                  }),
                  _GroupChip(
                    title: 'Add Group',
                    icon: Icons.add,
                    isSelected: false,
                    onTap: () {
                      // Show add group dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getIconForGroup(String name) {
    final n = name.toLowerCase();
    if (n.contains('work')) return Icons.work_outline;
    if (n.contains('home')) return Icons.home_outlined;
    if (n.contains('bank') || n.contains('finance')) return Icons.account_balance_outlined;
    return Icons.folder_outlined;
  }
}

class _GroupChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _GroupChip({
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        title,
        style: TextStyle(
          color: isSelected ? context.uiColors.backgroundPrimaryColor : context.uiColors.primaryTextColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      avatar: icon != null
          ? Icon(
              icon,
              size: 16,
              color: isSelected ? context.uiColors.backgroundPrimaryColor : context.uiColors.primaryTextColor,
            )
          : null,
      backgroundColor: isSelected ? context.uiColors.primaryColor : context.uiColors.secondaryColor,
      onPressed: onTap,
    );
  }
}
