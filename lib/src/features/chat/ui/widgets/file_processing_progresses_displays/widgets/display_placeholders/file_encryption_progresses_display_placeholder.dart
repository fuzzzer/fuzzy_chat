import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FileEncryptionProgressesDisplaylaceholder extends StatelessWidget {
  const FileEncryptionProgressesDisplaylaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return FileEncriptionCubitBuilder(
      builder: (context, state) {
        return SizedBox(
          height: state.currentProcessingFile != null ? FileEncryptionProgressDisplay.height : 0,
        );
      },
    );
  }
}
