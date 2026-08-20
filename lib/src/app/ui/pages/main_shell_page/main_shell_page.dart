import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';
import 'package:go_router/go_router.dart';

export 'widgets/widgets.dart';

class MainShellPage extends StatefulWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  // TODO: showing on every launch for now.
  static bool _tourShown = false;

  final GlobalKey _menuButtonKey = GlobalKey();
  final GlobalKey _rightActionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowTour());
  }

  void _maybeShowTour() {
    if (_tourShown || !mounted) return;
    _tourShown = true;

    final loc = context.fuzzyChatLocalizations;
    final currentLoc = GoRouterState.of(context).uri.toString();
    final isChat = currentLoc == AppRouter.home;
    final isVault = currentLoc.startsWith('/vault');

    final rightActionDescription = isChat
        ? loc.tourEncryptionActionDescription
        : isVault
            ? loc.tourVaultActionDescription
            : null;

    showAppTour(
      context,
      steps: [
        AppTourStep(
          targetKey: _menuButtonKey,
          title: loc.tourMenuTitle,
          description: loc.tourMenuDescription,
        ),
        if (rightActionDescription != null)
          AppTourStep(
            targetKey: _rightActionKey,
            title: loc.tourRightActionTitle,
            description: rightActionDescription,
          ),
      ],
      nextLabel: loc.tourNext,
      doneLabel: loc.tourGotIt,
    );
  }

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
      title = loc.fuzzyVault;
      rightAction = BlocBuilder<VaultAuthCubit, VaultAuthState>(
        builder: (context, state) {
          if (state.authState == VaultAuthEnum.unlocked) {
            return IconButton(
              icon: Icon(
                Icons.more_vert,
                color: context.fuzzzyColors.ink,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: context.fuzzzyColors.ground,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (sheetContext) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: context.fuzzzyColors.inkMute,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.lock_outline,
                                color: context.fuzzzyColors.ink,
                              ),
                              title: Text(
                                loc.vaultLockVault,
                                style: TextStyle(
                                  color: context.fuzzzyColors.ink,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(sheetContext).pop();
                                context.read<VaultAuthCubit>().lock();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      );
    }

    final shellAppBar = FuzzzyAppBar(
      title: title,
      leading: Builder(
        builder: (context) {
          return IconButton(
            key: _menuButtonKey,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.menu,
              color: context.fuzzzyColors.ink,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: rightAction != null
          ? [KeyedSubtree(key: _rightActionKey, child: rightAction)]
          : null,
    );

    return Scaffold(
      backgroundColor: context.fuzzzyColors.ground,
      drawer: const MainDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          shellAppBar.preferredSize.height + MediaQuery.of(context).padding.top,
        ),
        child: SafeArea(
          child: shellAppBar,
        ),
      ),
      body: widget.child,
    );
  }
}
