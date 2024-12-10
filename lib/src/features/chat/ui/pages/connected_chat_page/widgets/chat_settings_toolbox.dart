import 'package:flutter/material.dart';

import 'package:fuzzy_chat/lib.dart';

class SettingsToolbox extends StatefulWidget {
  final ChatGeneralData chatGeneralData;
  final void Function() onActionPressed;

  const SettingsToolbox({
    super.key,
    required this.chatGeneralData,
    required this.onActionPressed,
  });

  @override
  State<SettingsToolbox> createState() => _SettingsToolboxState();
}

class _SettingsToolboxState extends State<SettingsToolbox> {
  void _exportAcceptance() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AcceptanceExportPage(
          payload: AcceptanceExportPagePayload(
            chatGeneralData: widget.chatGeneralData,
            hasBackButton: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return IntrinsicWidth(
      child: FuzzyToolbox(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text(
              localizations.deleteChat,
            ),
            onTap: () {
              widget.onActionPressed();
              showChatDeletionDialog(
                context,
                chatId: widget.chatGeneralData.chatId,
                chatName: widget.chatGeneralData.chatName,
                onClosed: () {},
              );
            },
          ),
          if (widget.chatGeneralData.didAcceptInvitation)
            ListTile(
              leading: const Icon(Icons.file_upload),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                localizations.exportAcceptance,
              ),
              onTap: () {
                widget.onActionPressed();

                _exportAcceptance();
              },
            ),
        ],
      ),
    );
  }
}
