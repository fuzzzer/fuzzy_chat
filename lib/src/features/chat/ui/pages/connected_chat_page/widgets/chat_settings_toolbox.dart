import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fuzzy_chat/lib.dart';

class SettingsToolbox extends StatefulWidget {
  final ChatGeneralData chatGeneralData;
  final void Function() onActionPressed;
  final void Function() onChatDeleted;

  const SettingsToolbox({
    super.key,
    required this.chatGeneralData,
    required this.onActionPressed,
    required this.onChatDeleted,
  });

  @override
  State<SettingsToolbox> createState() => _SettingsToolboxState();
}

class _SettingsToolboxState extends State<SettingsToolbox> {
  void _exportAcceptance({
    required FuzzyChatLocalizations localizations,
  }) {
    final acceptanceReaderCubit = AcceptanceReaderCubit(
      handshakeManager: sl.get<HandshakeManager>(),
      keyStorageRepository: sl.get<KeyStorageRepository>(),
    );

    acceptanceReaderCubit.generateAcceptance(chatId: widget.chatGeneralData.chatId).then((_) {
      if (acceptanceReaderCubit.state.status.isSuccess) {
        _copyAcceptance(
          acceptanceContent: acceptanceReaderCubit.state.acceptance?.acceptanceContent ?? '',
          localizations: localizations,
        );
      } else {
        FuzzySnackbar.show(
          label: localizations.failedToGetAcceptance,
        );
      }
    });
  }

  void _copyAcceptance({
    required String acceptanceContent,
    required FuzzyChatLocalizations localizations,
  }) {
    Clipboard.setData(
      ClipboardData(
        text: acceptanceContent,
      ),
    ).then((_) {
      FuzzySnackbar.show(
        label: localizations.acceptanceCopiedToClipboard,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.fuzzyChatLocalizations;

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
                onChatDeleted: widget.onChatDeleted,
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
                _exportAcceptance(localizations: localizations);

                widget.onActionPressed();
              },
            ),
        ],
      ),
    );
  }
}
