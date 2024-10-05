import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pointycastle/impl.dart' as pointy;
import 'package:secure_chat/src/app/app.dart';
import 'package:secure_chat/src/core/utils/rsa_manager/rsa_manager.dart';

import '../../../core/utils/map_casting.dart';

class SendPage extends StatefulWidget {
  const SendPage({
    super.key,
    this.publicKey,
  });

  final pointy.RSAPublicKey? publicKey;

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final TextEditingController _plainTextController = TextEditingController();
  String _encryptedText = '';
  late DropzoneViewController _controller;
  bool _highlighted = false;

  late pointy.RSAPublicKey? publicKey;

  @override
  void initState() {
    publicKey = widget.publicKey;

    super.initState();
  }

  Future<void> _encrypt() async {
    if (publicKey == null) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Public key not loaded')),
      );
      return;
    }
    final plainText = _plainTextController.text;
    final encryptedText = await RSAManager.encrypt(plainText, publicKey!);
    setState(() {
      _encryptedText = encryptedText;
    });
  }

  Future<void> _importPublicKeyFromFile(dynamic event) async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final bytes = await _controller.getFileData(event);
      final jsonString = utf8.decode(bytes);
      final publicKeyMap = castMapToAllStringMap(json.decode(jsonString) as Map<String, dynamic>);
      final importedPublicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);
      setState(() {
        publicKey = importedPublicKey;
      });
      messenger?.showSnackBar(
        const SnackBar(content: Text('Public key imported successfully')),
      );
    } catch (e) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Failed to import public key')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Message')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _plainTextController,
                    decoration: const InputDecoration(
                      labelText: 'Plain Text',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _encrypt,
                    child: const Text('Encrypt'),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    _encryptedText,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _encryptedText));
                      scaffoldMessengerKey.currentState?.showSnackBar(
                        const SnackBar(content: Text('Decoded Text Copied')),
                      );
                    },
                    child: const Text('Copy Encrypted Text'),
                  ),
                ],
              ),
            ),
          ),
          if (kIsWeb)
            DropzoneView(
              onCreated: (controller) => _controller = controller,
              onDrop: (event) async {
                setState(() {
                  _highlighted = false;
                });
                await _importPublicKeyFromFile(event);
              },
              onHover: () {
                setState(() {
                  _highlighted = true;
                });
              },
              onLeave: () {
                setState(() {
                  _highlighted = false;
                });
              },
            ),
          if (_highlighted)
            ColoredBox(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Text(
                  'Drop the file here to import public key',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
