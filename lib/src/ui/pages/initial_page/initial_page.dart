import 'package:flutter/material.dart';

import '../recieve_setup_page.dart';
import '../send_setup_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
