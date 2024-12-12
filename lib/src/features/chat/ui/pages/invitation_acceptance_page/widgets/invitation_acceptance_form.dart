import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class InvitationAcceptanceForm extends StatelessWidget {
  final TextEditingController chatNameController;
  final TextEditingController invitationTextController;
  final VoidCallback onAccept;

  const InvitationAcceptanceForm({
    super.key,
    required this.chatNameController,
    required this.invitationTextController,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return FuzzyScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            FuzzyHeader(
              title: localizations.acceptChatInvitation,
            ),
            const Spacer(),
            FuzzyTextField(
              controller: chatNameController,
              labelText: localizations.enterChatName,
            ),
            const SizedBox(height: 16),
            FuzzyTextField(
              controller: invitationTextController,
              labelText: localizations.pasteInvitationText,
              maxLines: 3,
            ),
            const Spacer(),
          ],
        ),
      ),
      actionsRow: FuzzyActionsRow(
        isMainActionEnabled: chatNameController.text.isNotEmpty && invitationTextController.text.isNotEmpty,
        mainActionLabel: localizations.acceptInvitation,
        onMainActionPressed: onAccept,
      ),
    );
  }
}
