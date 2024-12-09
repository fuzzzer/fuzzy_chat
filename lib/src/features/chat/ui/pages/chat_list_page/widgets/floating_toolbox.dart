import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FloatingToolbox extends StatefulWidget {
  final VoidCallback onNewChatPressed;
  final VoidCallback onAcceptInvitationPressed;

  const FloatingToolbox({
    required this.onNewChatPressed,
    required this.onAcceptInvitationPressed,
    super.key,
  });

  @override
  State<FloatingToolbox> createState() => _FloatingToolboxState();
}

class _FloatingToolboxState extends State<FloatingToolbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    final localizations = FuzzyChatLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'createChat',
                  onPressed: () {
                    _toggleMenu();
                    widget.onNewChatPressed();
                  },
                  icon: const Icon(Icons.add),
                  backgroundColor: uiColors.secondaryColor,
                  foregroundColor: uiColors.backgroundPrimaryColor,
                  label: SizedBox(
                    width: 70,
                    child: Text(
                      localizations.newChat,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 64),
                  child: FloatingActionButton.extended(
                    heroTag: 'acceptInvitation',
                    onPressed: () {
                      _toggleMenu();
                      widget.onAcceptInvitationPressed();
                    },
                    icon: const Icon(Icons.mail),
                    backgroundColor: uiColors.secondaryColor,
                    foregroundColor: uiColors.backgroundPrimaryColor,
                    label: SizedBox(
                      width: 70,
                      child: Text(
                        localizations.acceptInvitation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FloatingActionButton(
            onPressed: _toggleMenu,
            backgroundColor: uiColors.secondaryColor,
            foregroundColor: uiColors.backgroundPrimaryColor,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _animation,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
