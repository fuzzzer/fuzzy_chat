import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class SettingsToolbox extends StatefulWidget {
  final ChatGeneralData chatGeneralData;

  const SettingsToolbox({
    super.key,
    required this.chatGeneralData,
  });

  @override
  State<SettingsToolbox> createState() => _SettingsToolboxState();
}

class _SettingsToolboxState extends State<SettingsToolbox> {
  Future<void> _deleteChat() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        final localizations = FuzzyChatLocalizations.of(context)!;

        return AlertDialog(
          title: Text(localizations.deleteChat),
          content: Text(
            localizations.areYouSureYouWantToDeleteThisChat,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO add delete chat functionality, delete chat completely with keys and everything

                // context.read<ConnectedChatCubit>().deleteChat();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                localizations.delete,
              ),
            ),
          ],
        );
      },
    );
  }

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
            onTap: _deleteChat,
          ),
          if (widget.chatGeneralData.didAcceptInvitation)
            ListTile(
              leading: const Icon(Icons.file_upload),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(
                localizations.exportAcceptance,
              ),
              onTap: _exportAcceptance,
            ),
        ],
      ),
    );
  }
}
