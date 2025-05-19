import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FileEncryptionProgressesDisplaylaceholder extends StatelessWidget {
  const FileEncryptionProgressesDisplaylaceholder({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return FileEncriptionCubitBuilder(
      builder: (context, state) {
        return SizedBox(
          height: state.currentProcessingFile?.chatId == chatId ? FileEncryptionProgressDisplay.height : 0,
        );
      },
    );
  }
}
