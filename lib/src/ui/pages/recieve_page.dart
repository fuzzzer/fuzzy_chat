import 'package:flutter/material.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;

import '../../core/utils/security_logic.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({
    required this.privateKey,
    super.key,
  });

  final pointy.RSAPrivateKey privateKey;

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  final TextEditingController _encryptedTextController = TextEditingController();
  final TextEditingController _plainTextController = TextEditingController();

  void _decrypt() {
    final toBeEncryptedText = _encryptedTextController.text;
    final decryptedText = RSAManager.decrypt(toBeEncryptedText, widget.privateKey);
    setState(() {
      _plainTextController.text = decryptedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive Message')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _encryptedTextController,
              decoration: const InputDecoration(
                labelText: 'Encrypted Text',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _decrypt,
              child: const Text('Decrypt'),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _plainTextController,
              decoration: const InputDecoration(
                labelText: 'Plain Text',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
