import 'package:flutter/material.dart';

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
                  label: const SizedBox(
                    width: 70,
                    child: Text(
                      'New Chat',
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
                    label: const SizedBox(
                      width: 70,
                      child: Text(
                        'Accept Invitation',
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
