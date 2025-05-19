import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:pointycastle/export.dart';

//TODO while getting symmetric keys, require password or pin authentication for additionaly secured chats
class KeyStorageRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> savePrivateKey(String chatId, RSAPrivateKey privateKey) async {
    final privateKeyMap = RSAService.transformRSAPrivateKeyToMap(privateKey);
    await _secureStorage.write(key: 'privateKey_$chatId', value: jsonEncode(privateKeyMap));
  }

  Future<void> savePublicKey(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAService.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(key: 'publicKey_$chatId', value: jsonEncode(publicKeyMap));
  }

  Future<RSAPrivateKey?> getPrivateKey(String chatId) async {
    final privateKeyJson = await _secureStorage.read(key: 'privateKey_$chatId');

    if (privateKeyJson != null) {
      return RSAService.transformMapToRSAPrivateKey(
        (jsonDecode(privateKeyJson) as Map<String, dynamic>).cast(),
      );
    }
    return null;
  }

  Future<RSAPublicKey?> getPublicKey(String chatId) async {
    final publicKeyJson = await _secureStorage.read(key: 'publicKey_$chatId');

    if (publicKeyJson != null) {
      return RSAService.transformMapToRSAPublicKey(
        (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast(),
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

  Future<void> saveOtherPartyPublicKey(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAService.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(key: 'otherPartyPublicKey_$chatId', value: jsonEncode(publicKeyMap));
  }

  Future<RSAPublicKey?> getOtherPartyPublicKey(String chatId) async {
    final publicKeyJson = await _secureStorage.read(key: 'otherPartyPublicKey_$chatId');
    if (publicKeyJson != null) {
      return RSAService.transformMapToRSAPublicKey(
        (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast(),
      );
    }
    return null;
  }

  /// Clears all keys related to the given [chatId].
  Future<void> clearAllKeysForChat(String chatId) async {
    await _secureStorage.delete(key: 'privateKey_$chatId');
    await _secureStorage.delete(key: 'publicKey_$chatId');
    await _secureStorage.delete(key: 'symmetricKey_$chatId');
    await _secureStorage.delete(key: 'otherPartyPublicKey_$chatId');
  }
}
