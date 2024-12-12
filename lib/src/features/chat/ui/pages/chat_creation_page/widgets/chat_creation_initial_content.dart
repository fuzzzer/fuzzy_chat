import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class ChatCreationInitialContent extends StatelessWidget {
  final TextEditingController chatNameController;
  final FocusNode focusNode;
  final VoidCallback onCreate;

  const ChatCreationInitialContent({
    super.key,
    required this.chatNameController,
    required this.focusNode,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return FuzzyScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FuzzyHeader(
              title: localizations.createANewChat,
            ),
            const Spacer(),
            FuzzyTextField(
              controller: chatNameController,
              focusNode: focusNode,
              labelText: localizations.enterChatName,
              hintText: '${localizations.eg} ${localizations.chatWithAlice}',
            ),
            const Spacer(),
          ],
        ),
      ),
      actionsRow: FuzzyActionsRow(
        isMainActionEnabled: chatNameController.text.isNotEmpty,
        mainActionLabel: localizations.create,
        onMainActionPressed: onCreate,
      ),
    );
  }
}
