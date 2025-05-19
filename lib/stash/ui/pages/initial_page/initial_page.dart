import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzy_chat/stash/ui/pages/recieve_setup_page.dart';
import 'package:fuzzy_chat/stash/ui/pages/send_setup_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FuzzyScaffold(
      appBar: AppBar(title: const Text('RSA Encrypter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const SendSetupPage(),
                  ),
                );
              },
              child: const Text('Send Message'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ReceiveSetupPage(),
                  ),
                );
              },
              child: const Text('Receive Message'),
            ),
          ],
        ),
      ),
    );
  }
}
