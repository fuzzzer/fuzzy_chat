// key_storage_service.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:pointycastle/export.dart';

class KeyStorageRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> savePrivateKey(String chatId, RSAPrivateKey privateKey) async {
    final privateKeyMap = RSAManager.transformRSAPrivateKeyToMap(privateKey);
    await _secureStorage.write(key: 'privateKey_$chatId', value: jsonEncode(privateKeyMap));
  }

  Future<void> savePublicKey(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(key: 'publicKey_$chatId', value: jsonEncode(publicKeyMap));
  }

  Future<RSAPrivateKey?> getPrivateKey(String chatId) async {
    final privateKeyJson = await _secureStorage.read(key: 'privateKey_$chatId');
    if (privateKeyJson != null) {
      return RSAManager.transformMapToRSAPrivateKey(
        jsonDecode(privateKeyJson) as Map<String, String>,
      );
    }
    return null;
  }

  Future<RSAPublicKey?> getPublicKey(String chatId) async {
    final publicKeyJson = await _secureStorage.read(key: 'publicKey_$chatId');
    if (publicKeyJson != null) {
      return RSAManager.transformMapToRSAPublicKey(
        jsonDecode(publicKeyJson) as Map<String, String>,
      );
    }
    return null;
  }

  Future<void> saveSymmetricKey(String chatId, Uint8List symmetricKey) async {
    final keyBase64 = base64Encode(symmetricKey);
    await _secureStorage.write(key: 'symmetricKey_$chatId', value: keyBase64);
  }

  Future<Uint8List?> getSymmetricKey(String chatId) async {
    final keyBase64 = await _secureStorage.read(key: 'symmetricKey_$chatId');
    if (keyBase64 != null) {
      return base64Decode(keyBase64);
    }
    return null;
  }

  Future<void> saveRecipientPublicKey(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(key: 'recipientPublicKey_$chatId', value: jsonEncode(publicKeyMap));
  }

  Future<RSAPublicKey?> getRecipientPublicKey(String chatId) async {
    final publicKeyMap = await _secureStorage.read(key: 'recipientPublicKey_$chatId');
    if (publicKeyMap != null) {
      return RSAManager.transformMapToRSAPublicKey(
        jsonDecode(publicKeyMap) as Map<String, String>,
      );
    }
    return null;
  }
}
