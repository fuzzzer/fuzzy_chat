import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.fuzzyChatLocalizations;
    final prefs = sl.get<PreferencesService>();
    final currentLoc = GoRouterState.of(context).uri.toString();

    final isChat = currentLoc == AppRouter.home;
    final isVault = currentLoc.startsWith('/vault');

    return Drawer(
      backgroundColor: context.uiColors.backgroundPrimaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.uiColors.primaryTextColor,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.chat_bubble_outline,
                color: isChat ? context.uiColors.primaryColor : context.uiColors.secondaryTextColor,
              ),
              title: Text(
                loc.fuzzyChat,
                style: TextStyle(
                  color: isChat ? context.uiColors.primaryColor : context.uiColors.primaryTextColor,
                  fontWeight: isChat ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                prefs.setLastSelectedTab(AppRouter.home);
                context.go(AppRouter.home);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.lock_outline,
                color: isVault ? context.uiColors.primaryColor : context.uiColors.secondaryTextColor,
              ),
              title: Text(
                'Fuzzy Vault',
                style: TextStyle(
                  color: isVault ? context.uiColors.primaryColor : context.uiColors.primaryTextColor,
                  fontWeight: isVault ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                prefs.setLastSelectedTab('/vault');
                context.go('/vault');
              },
            ),
            const Spacer(),
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: context.uiColors.secondaryTextColor,
              ),
              title: Text(
                loc.settings,
                style: TextStyle(
                  color: context.uiColors.primaryTextColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRouter.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}
