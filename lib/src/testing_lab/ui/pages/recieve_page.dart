import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:fuzzy_chat/src/app/app.dart';

import '../../../core/utils/rsa_manager/rsa_manager.dart';

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
  String _decryptedText = '';

  Future<void> _decrypt() async {
    final toBeEncryptedText = _encryptedTextController.text;
    final newDecryptedText = await RSAManager.decrypt(toBeEncryptedText, widget.privateKey);
    setState(() {
      _decryptedText = newDecryptedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive Message')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
              Text(
                _decryptedText,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _decryptedText));
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Decoded Text Copied')),
                  );
                },
                child: const Text('Copy Decrypted Text'),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
