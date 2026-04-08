import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/export.dart';

//TODO while getting symmetric keys, require password or pin authentication for additionaly secured chats
class KeyStorageRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> savePrivateKey(String chatId, RSAPrivateKey privateKey) async {
    final password = sl.get<FuzzyAuthStore>().state.authData.password;
    final privateKeyMap = RSAService.transformRSAPrivateKeyToMap(privateKey);
    final privateKeyJson = jsonEncode(privateKeyMap);
    final privateKeyBytes = Uint8List.fromList(utf8.encode(privateKeyJson));

    final encryptedPrivateKey = await PasswordBasedEncryptionSevice.encrypt(privateKeyBytes, password);
    final encryptedPrivateKeyBase64 = base64Encode(encryptedPrivateKey);

    await _secureStorage.write(key: 'privateKey_$chatId', value: encryptedPrivateKeyBase64);
  }

  Future<void> savePublicKey(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAService.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(key: 'publicKey_$chatId', value: jsonEncode(publicKeyMap));
  }

  Future<RSAPrivateKey?> getPrivateKey(String chatId) async {
    final password = sl.get<FuzzyAuthStore>().state.authData.password;
    final privateKeyData = await _secureStorage.read(key: 'privateKey_$chatId');

    if (privateKeyData != null) {
      if (privateKeyData.startsWith('{')) {
        return RSAService.transformMapToRSAPrivateKey(
          (jsonDecode(privateKeyData) as Map<String, dynamic>).cast(),
        );
      } else {
        final encryptedPrivateKey = base64Decode(privateKeyData);
        final decryptedBytes = await PasswordBasedEncryptionSevice.decrypt(encryptedPrivateKey, password);
        final privateKeyJson = utf8.decode(decryptedBytes);

        return RSAService.transformMapToRSAPrivateKey(
          (jsonDecode(privateKeyJson) as Map<String, dynamic>).cast(),
        );
      }
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
    final password = sl.get<FuzzyAuthStore>().state.authData.password;

    final encryptedSymmetricKey = await PasswordBasedEncryptionSevice.encrypt(symmetricKey, password);
    final encryptedSymmetricKeyBase64 = base64Encode(encryptedSymmetricKey);

    await _secureStorage.write(key: 'symmetricKey_$chatId', value: encryptedSymmetricKeyBase64);
  }

  Future<Uint8List?> getSymmetricKey(String chatId) async {
    final password = sl.get<FuzzyAuthStore>().state.authData.password;

    final encryptedSymmetricKeyBase64 = await _secureStorage.read(key: 'symmetricKey_$chatId');
    if (encryptedSymmetricKeyBase64 != null) {
      final encryptedSymmetricKey = base64Decode(encryptedSymmetricKeyBase64);
      final symmetricKey = await PasswordBasedEncryptionSevice.decrypt(encryptedSymmetricKey, password);

      return symmetricKey;
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
