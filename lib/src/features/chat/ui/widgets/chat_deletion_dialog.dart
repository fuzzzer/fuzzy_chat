import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

Future<void> showChatDeletionDialog(
  BuildContext context, {
  required String chatName,
  required String chatId,
  void Function()? onClosed,
}) async {
  await showDialog<bool>(
    context: context,
    builder: (context) {
      final localizations = FuzzyChatLocalizations.of(context)!;

      return AlertDialog(
        title: Text(localizations.deleteChat),
        content: Text(
          localizations.areYouSureYouWantToDeleteChatWith(chatName),
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
              context.read<ChatGeneralDataListCubit>().deleteChat(
                    chatId: chatId,
                  );
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
