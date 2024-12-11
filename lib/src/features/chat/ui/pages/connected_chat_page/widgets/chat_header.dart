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
                //TODO find better fix, so that offest is dynamically deduced
                offset: chatGeneralData.didAcceptInvitation ? const Offset(-200, 0) : const Offset(-150, 0),
                spawnedChildBuilder: (_, closeOverlay) => SettingsToolbox(
                  chatGeneralData: chatGeneralData,
                  onActionPressed: () {
                    closeOverlay();
                  },
                  onChatDeleted: () {
                    Navigator.of(context).pop();
                  },
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
