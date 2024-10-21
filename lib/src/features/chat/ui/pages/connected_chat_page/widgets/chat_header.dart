import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

class ChatHeader extends StatelessWidget {
  final String chatName;
  final VoidCallback onBackPressed;
  final VoidCallback onSettingsPressed;

  const ChatHeader({
    required this.chatName,
    required this.onBackPressed,
    required this.onSettingsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return ColoredBox(
      color: uiColors.backgroundPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 4,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            ),
            const SizedBox(width: 8),
            Text(
              chatName,
              style: uiTextStyles.bodyLargeBold20,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: onSettingsPressed,
            ),
          ],
        ),
      ),
    );
  }
}
