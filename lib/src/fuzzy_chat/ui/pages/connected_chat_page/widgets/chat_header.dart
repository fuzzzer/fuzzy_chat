import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';

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
    final fuzzzyColors = context.fuzzzyColors;
    final fuzzzyTextStyles = context.fuzzzyTextStyles;

    return ColoredBox(
      color: fuzzzyColors.ground,
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
              style: fuzzzyTextStyles.titleM.copyWith(color: fuzzzyColors.ink),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FuzzyOverlaySpawner(
                //TODO find better fix, so that offest is dynamically deduced
                offset: chatGeneralData.didAcceptInvitation
                    ? const Offset(-200, 0)
                    : const Offset(-150, 0),
                spawnedChildBuilder: (_, closeOverlay) => SettingsToolbox(
                  chatGeneralData: chatGeneralData,
                  onActionPressed: () {
                    closeOverlay();
                  },
                  onChatDeleted: () => context.goBack(),
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
