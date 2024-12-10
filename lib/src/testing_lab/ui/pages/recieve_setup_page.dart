import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/pointycastle.dart' as pointy;

class ReceiveSetupPage extends StatefulWidget {
  const ReceiveSetupPage({super.key});

  @override
  State<ReceiveSetupPage> createState() => _ReceiveSetupPageState();
}

class _ReceiveSetupPageState extends State<ReceiveSetupPage> {
  bool isLoadingKeys = false;
  pointy.AsymmetricKeyPair<pointy.RSAPublicKey, pointy.RSAPrivateKey>? _keyPair;
  late DropzoneViewController _controller;
  bool _highlighted = false;

  @override
  void initState() {
    super.initState();
    _loadOrGenerateKeys();
  }

  Future<void> _loadOrGenerateKeys() async {
    setState(() {
      isLoadingKeys = true;
    });

    final messenger = scaffoldMessengerKey.currentState;

    try {
      final publicKey = await KeysRepository.loadPublicKeyFromFile('public_key.json');
      final privateKey = await KeysRepository.loadPrivateKeyFromFile('private_key.json');
      setState(() {
        _keyPair = pointy.AsymmetricKeyPair(publicKey, privateKey);
      });

      messenger?.showSnackBar(
        const FuzzySnackBar(label: 'Loaded Existing Keys'),
      );
    } catch (e) {
      await _generateNewKeys();
    }

    setState(() {
      isLoadingKeys = false;
    });
  }

  Future<void> _generateNewKeys() async {
    setState(() {
      isLoadingKeys = true;
    });

    final messenger = scaffoldMessengerKey.currentState;

    messenger?.showSnackBar(
      const FuzzySnackBar(label: 'Generating New Keys'),
    );

    final newKeyPair = await Isolate.run(RSAManager.generateRSAKeyPair);

    setState(() {
      _keyPair = newKeyPair;
      KeysRepository.savePublicKeyToFile(newKeyPair.publicKey, 'public_key.json');
      KeysRepository.savePrivateKeyToFile(newKeyPair.privateKey, 'private_key.json');
    });

    messenger?.showSnackBar(
      const FuzzySnackBar(label: 'Generated New Keys'),
    );
    setState(() {
      isLoadingKeys = false;
    });
  }

  Future<void> _importKeyFromFile(DropzoneFileInterface event) async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final bytes = await _controller.getFileData(event);
      final jsonString = utf8.decode(bytes);
      final keyMap = castMapToAllStringMap(json.decode(jsonString) as Map<String, dynamic>);
      _parseAndImportKeys(keyMap);
    } catch (e) {
      messenger?.showSnackBar(
        const FuzzySnackBar(label: 'Failed to import keys'),
      );
    }
  }

  Future<void> _importKeyFromPicker() async {
    final messenger = scaffoldMessengerKey.currentState;
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final fileContent = await File(result.files.first.path!).readAsString();

        final originalString = base64Decode(fileContent);
        final jsonString = utf8.decode(originalString);
        final keyMap = castMapToAllStringMap(json.decode(jsonString) as Map<String, dynamic>);
        _parseAndImportKeys(keyMap);
      }
    } catch (e) {
      messenger?.showSnackBar(
        const FuzzySnackBar(label: 'Failed to import keys'),
      );
    }
  }

  void _parseAndImportKeys(Map<String, String> keyMap) {
    var isPrivateKeyLoaded = false;

    pointy.RSAPublicKey? importedPublicKey;
    try {
      importedPublicKey = RSAManager.transformMapToRSAPublicKey(keyMap);
      KeysRepository.savePublicKeyToFile(importedPublicKey, 'public_key.json');
      debugPrint('Public key imported successfully');
    } catch (e) {
      importedPublicKey = null;
      debugPrint('Public key not found in file');
    }

    try {
      final importedPrivateKey = RSAManager.transformMapToRSAPrivateKey(keyMap);

      importedPublicKey ??= pointy.RSAPublicKey(
        importedPrivateKey.n!,
        importedPrivateKey.publicExponent!,
      );

      setState(() {
        _keyPair = pointy.AsymmetricKeyPair(importedPublicKey!, importedPrivateKey);
      });

      isPrivateKeyLoaded = true;

      KeysRepository.savePublicKeyToFile(importedPublicKey, 'public_key.json');
      KeysRepository.savePrivateKeyToFile(importedPrivateKey, 'private_key.json');
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const FuzzySnackBar(label: 'Could Not Import Private Key'),
      );
    }

    if (isPrivateKeyLoaded) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const FuzzySnackBar(label: 'Keys imported successfully'),
      );
    }
  }

  Future<void> _showKeysCustomizedDialog([bool readsLocalFile = false]) async {
    var publicKeyMap = _keyPair == null ? '' : RSAManager.transformRSAPublicKeyToMap(_keyPair!.publicKey);
    var privateKeyMap = _keyPair == null ? '' : RSAManager.transformRSAPrivateKeyToMap(_keyPair!.privateKey);

    if (readsLocalFile) {
      await Future.wait([
        (() async => KeysRepository.loadPublicKeyFromFile('public_key.json'))(),
        (() async => KeysRepository.loadPrivateKeyFromFile('private_key.json'))(),
      ]).then((value) {
        setState(() {
          publicKeyMap = RSAManager.transformRSAPublicKeyToMap(value[0] as RSAPublicKey);
          privateKeyMap = RSAManager.transformRSAPrivateKeyToMap(value[1] as RSAPrivateKey);
        });
        showKeysDialog(
          publicKeyMap: publicKeyMap,
          privateKeyMap: privateKeyMap,
        );
      });
    } else {
      showKeysDialog(
        publicKeyMap: publicKeyMap,
        privateKeyMap: privateKeyMap,
      );
    }
  }

  void showKeysDialog({
    required dynamic publicKeyMap,
    required dynamic privateKeyMap,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        final base64Public = base64Encode(utf8.encode(json.encode(publicKeyMap)));
        final base64Private = base64Encode(utf8.encode(json.encode(privateKeyMap)));

        return AlertDialog(
          title: const Text('Keys'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: base64Public));
                    scaffoldMessengerKey.currentState?.showSnackBar(
                      const FuzzySnackBar(label: 'Public key copied to clipboard'),
                    );
                  },
                  child: const Text('Copy Public Key'),
                ),
                const Text('Public Key:'),
                Text(base64Public),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: base64Private));
                    scaffoldMessengerKey.currentState?.showSnackBar(
                      const FuzzySnackBar(label: 'Private key copied to clipboard'),
                    );
                  },
                  child: const Text('Copy Private Key'),
                ),
                const Text('Private Key:'),
                Text(base64Private),
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
            TextButton(
              onPressed: _keyPair == null
                  ? null
                  : () {
                      exportKeys(_keyPair!);
                    },
              child: const Text('Export Secure Keys'),
            ),
            TextButton(
              onPressed: _keyPair == null
                  ? null
                  : () {
                      exportPublicKey(_keyPair!.publicKey);
                    },
              child: const Text('Export Public Key'),
            ),
          ],
        );
      },
    );
  }

  Future<void> exportKeys(pointy.AsymmetricKeyPair<pointy.RSAPublicKey, pointy.RSAPrivateKey> keyPair) async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final resultPrivate = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Private Key',
        fileName: 'exported_private_key.json',
      );

      if (resultPrivate != null) {
        final privateKeyFile = File(resultPrivate);
        final privateKeyMap = RSAManager.transformRSAPrivateKeyToMap(keyPair.privateKey);
        await privateKeyFile.writeAsString(base64Encode(utf8.encode(json.encode(privateKeyMap))));

        messenger?.showSnackBar(
          const FuzzySnackBar(label: 'Private key exported successfully'),
        );
      }
    } catch (e) {
      messenger?.showSnackBar(
        const FuzzySnackBar(label: 'Failed to export private key'),
      );
      debugPrint('Failed to export private key: $e');
    }
  }

  Future<void> exportPublicKey(pointy.RSAPublicKey publicKey) async {
    final messenger = scaffoldMessengerKey.currentState;

    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Public Key',
        fileName: 'exported_public_key.json',
      );

      if (result != null) {
        final publicKeyFile = File(result);
        final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(publicKey);
        await publicKeyFile.writeAsString(base64Encode(utf8.encode(json.encode(publicKeyMap))));

        messenger?.showSnackBar(
          const FuzzySnackBar(label: 'Public key exported successfully'),
        );
      }
    } catch (e) {
      messenger?.showSnackBar(
        const FuzzySnackBar(label: 'Failed to export public key'),
      );
      debugPrint('Failed to export public key: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FuzzyScaffold(
      appBar: AppBar(title: const Text('Receive Setup')),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoadingKeys)
                    const CircularProgressIndicator()
                  else
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _generateNewKeys,
                          child: const Text('Generate New Keys'),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _showKeysCustomizedDialog,
                          child: const Text('Show Keys'),
                        ),
                        // const SizedBox(height: 50),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     _showKeysCustomizedDialog(true);
                        //   },
                        //   child: const Text('Show Local Stored Keys'),
                        // ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _importKeyFromPicker,
                          child: const Text('Import Keys from File'),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _keyPair == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) => ReceivePage(
                                        privateKey: _keyPair!.privateKey,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text('Proceed to Receive Message'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (kIsWeb)
            DropzoneView(
              onCreated: (controller) => _controller = controller,
              onDropFile: (event) async {
                setState(() {
                  _highlighted = false;
                });
                await _importKeyFromFile(event);
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
                  'Drop the file here to import key',
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
