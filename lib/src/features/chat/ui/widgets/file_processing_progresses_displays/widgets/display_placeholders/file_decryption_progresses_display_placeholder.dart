import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FileDecryptionProgressesDisplaylaceholder extends StatelessWidget {
  const FileDecryptionProgressesDisplaylaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return FileDecriptionCubitBuilder(
      builder: (context, state) {
        return SizedBox(
          height: state.currentProcessingFile != null ? FileEncryptionProgressDisplay.height : 0,
        );
      },
    );
  }
}
