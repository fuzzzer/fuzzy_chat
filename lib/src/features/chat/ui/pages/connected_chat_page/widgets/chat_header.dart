import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class ChatHeader extends StatelessWidget {
  final ChatGeneralData chatGeneralData;
  final VoidCallback onBackPressed;

  const ChatHeader({
    required this.chatGeneralData,
    required this.onBackPressed,
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
          top: 16,
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
              chatGeneralData.chatName,
              style: uiTextStyles.bodyLargeBold20,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FuzzyOverlaySpawner(
                spawnedChild: SettingsToolbox(
                  chatGeneralData: chatGeneralData,
                ),
                child: const Icon(
                  Icons.settings,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
