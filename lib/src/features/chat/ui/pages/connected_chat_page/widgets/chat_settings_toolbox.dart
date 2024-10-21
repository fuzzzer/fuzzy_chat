import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

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
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              //TODO add delete chat functionality, delete chat completely with keys and everything

              // context.read<ConnectedChatCubit>().deleteChat();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
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
    return IntrinsicWidth(
      child: FuzzyToolbox(
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Chat'),
            onTap: _deleteChat,
          ),
          if (widget.chatGeneralData.didAcceptInvitation)
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Export Acceptance'),
              onTap: _exportAcceptance,
            ),
        ],
      ),
    );
  }
}
