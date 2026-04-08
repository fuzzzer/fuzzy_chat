import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/fuzzy_basics/ui/pages/basic_encryption_page/basic_encryption_page.dart';

class BasicEncryptionNavigatorAction extends StatelessWidget {
  const BasicEncryptionNavigatorAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const BasicEncryptionPage(),
          ),
        );
      },
      icon: const Icon(Icons.key),
    );
  }
}
