import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

export 'widgets/widgets.dart';

class MainShellPage extends StatelessWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentLoc = GoRouterState.of(context).uri.toString();
    final isChat = currentLoc == AppRouter.home;
    final isVault = currentLoc.startsWith('/vault');
    final loc = context.fuzzyChatLocalizations;

    String title = '';
    Widget? rightAction;

    if (isChat) {
      title = loc.fuzzyChat;
      rightAction = const BasicEncryptionNavigatorAction();
    } else if (isVault) {
      title = 'Fuzzy Vault';
      rightAction = BlocBuilder<VaultAuthCubit, VaultAuthState>(
        builder: (context, state) {
          if (state.authState == VaultAuthEnum.unlocked) {
            return IconButton(
              icon: Icon(Icons.lock_outline, color: context.uiColors.primaryTextColor),
              onPressed: () {
                context.read<VaultAuthCubit>().lock();
              },
            );
          }
          return const SizedBox();
        },
      );
    }

    return Scaffold(
      backgroundColor: context.uiColors.backgroundPrimaryColor,
      drawer: const MainDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: FuzzyHeader(
            title: title,
            leftAction: Builder(
              builder: (context) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.menu, color: context.uiColors.primaryTextColor),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            rightAction: rightAction,
          ),
        ),
      ),
      body: child,
    );
  }
}
