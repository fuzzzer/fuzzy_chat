import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;
import 'package:secure_chat/src/app/app.dart';
import 'package:secure_chat/src/core/utils/keys_repository/keys_repository.dart';

import '../../../core/utils/map_casting.dart';
import '../../../core/utils/rsa_manager/rsa_manager.dart';
import 'send_page.dart';

class SendSetupPage extends StatefulWidget {
  const SendSetupPage({super.key});

  @override
  State<SendSetupPage> createState() => _SendSetupPageState();
}

class _SendSetupPageState extends State<SendSetupPage> {
  pointy.RSAPublicKey? _publicKey;
  late DropzoneViewController _controller;
  bool _highlighted = false;
  final TextEditingController _publicKeyController = TextEditingController();

  Future<void> _importPublicKeyFromFile(dynamic event) async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final bytes = await _controller.getFileData(event);
      final originalStringBytes = base64Decode(utf8.decode(bytes));
      final jsonString = utf8.decode(originalStringBytes);
      final publicKeyMap = castMapToAllStringMap(json.decode(jsonString) as Map<String, dynamic>);
      final importedPublicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);
      setState(() {
        _publicKey = importedPublicKey;
      });
      await KeysRepository.savePublicKeyToFile(importedPublicKey, 'public_key.json');
      messenger?.showSnackBar(
        const SnackBar(content: Text('Public key imported successfully')),
      );
      _showPublicKeyDialog(importedPublicKey);
    } catch (e) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Failed to import public key')),
      );
    }
  }

  Future<void> _importPublicKeyFromPicker() async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final fileContent = await File(result.files.first.path!).readAsString();

        final originalString = base64Decode(fileContent);
        final jsonString = utf8.decode(originalString);
        final publicKeyMap = castMapToAllStringMap(json.decode(jsonString) as Map<String, dynamic>);
        final importedPublicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);
        setState(() {
          _publicKey = importedPublicKey;
        });
        await KeysRepository.savePublicKeyToFile(importedPublicKey, 'public_key.json');
        messenger?.showSnackBar(
          const SnackBar(content: Text('Public key imported successfully')),
        );
      }
    } catch (e) {
      messenger?.showSnackBar(
        SnackBar(content: Text('Failed to import public key: $e')),
      );
    }
  }

  Future<void> _importPublicKeyFromString(String publicKeyString) async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final originalString = base64Decode(publicKeyString);
      final jsonString = utf8.decode(originalString);
      final publicKeyMap = castMapToAllStringMap(json.decode(jsonString) as Map<String, dynamic>);
      final importedPublicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);

      setState(() {
        _publicKey = importedPublicKey;
      });
      await KeysRepository.savePublicKeyToFile(importedPublicKey, 'public_key.json');
      messenger?.showSnackBar(
        const SnackBar(content: Text('Public key imported successfully')),
      );
      _showPublicKeyDialog(importedPublicKey);
    } catch (e) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Invalid public key string')),
      );
    }
  }

  void _showPublicKeyInputDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Public Key'),
          content: TextField(
            controller: _publicKeyController,
            decoration: const InputDecoration(
              hintText: 'Enter public key as JSON string',
            ),
            maxLines: 10,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final publicKeyString = _publicKeyController.text;
                _importPublicKeyFromString(publicKeyString);
                Navigator.of(context).pop();
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  void _showPublicKeyDialog(pointy.RSAPublicKey? publicKey) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Imported Public Key'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Public Key:'),
                SelectableText(
                  publicKey == null ? 'not added' : RSAManager.transformRSAPublicKeyToMap(publicKey).toString(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Setup')),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _showPublicKeyInputDialog,
                    child: const Text('Enter Public Key Manually'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _importPublicKeyFromPicker,
                    child: const Text('Choose Public Key File'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      _showPublicKeyDialog(_publicKey);
                    },
                    child: const Text('Show Current Public Key'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _publicKey == null ? Colors.grey : null,
                    ),
                    onPressed: () {
                      if (_publicKey != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => SendPage(
                              publicKey: _publicKey,
                            ),
                          ),
                        );
                      } else {
                        scaffoldMessengerKey.currentState?.showSnackBar(
                          const SnackBar(content: Text('No public key loaded')),
                        );
                      }
                    },
                    child: const Text('Proceed to Send Message'),
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
