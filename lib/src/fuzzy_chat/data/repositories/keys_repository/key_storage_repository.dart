import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/export.dart';

class KeyStorageRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> savePrivateKey(String chatId, RSAPrivateKey privateKey) async {
    final password = sl.get<FuzzyAuthStore>().state.authData.password;
    final privateKeyMap = RSAService.transformRSAPrivateKeyToMap(privateKey);
    final privateKeyJson = jsonEncode(privateKeyMap);
    final privateKeyBytes = Uint8List.fromList(utf8.encode(privateKeyJson));

    final encryptedPrivateKey =
        await PasswordBasedEncryptionSevice.encrypt(privateKeyBytes, password);
    final encryptedPrivateKeyBase64 = base64Encode(encryptedPrivateKey);

    await _secureStorage.write(
        key: 'privateKey_$chatId', value: encryptedPrivateKeyBase64);
  }

  Future<void> savePublicKey(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAService.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(
        key: 'publicKey_$chatId', value: jsonEncode(publicKeyMap));
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
        final decryptedBytes = await PasswordBasedEncryptionSevice.decrypt(
            encryptedPrivateKey, password);
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

    final encryptedSymmetricKey =
        await PasswordBasedEncryptionSevice.encrypt(symmetricKey, password);
    final encryptedSymmetricKeyBase64 = base64Encode(encryptedSymmetricKey);

    await _secureStorage.write(
        key: 'symmetricKey_$chatId', value: encryptedSymmetricKeyBase64);
  }

  Future<Uint8List?> getSymmetricKey(String chatId) async {
    final password = sl.get<FuzzyAuthStore>().state.authData.password;

    final encryptedSymmetricKeyBase64 =
        await _secureStorage.read(key: 'symmetricKey_$chatId');
    if (encryptedSymmetricKeyBase64 != null) {
      final encryptedSymmetricKey = base64Decode(encryptedSymmetricKeyBase64);
      final symmetricKey = await PasswordBasedEncryptionSevice.decrypt(
          encryptedSymmetricKey, password);

      return symmetricKey;
    }

    return null;
  }

  Future<void> saveOtherPartyPublicKey(
      String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAService.transformRSAPublicKeyToMap(publicKey);
    await _secureStorage.write(
        key: 'otherPartyPublicKey_$chatId', value: jsonEncode(publicKeyMap));
  }

  Future<RSAPublicKey?> getOtherPartyPublicKey(String chatId) async {
    final publicKeyJson =
        await _secureStorage.read(key: 'otherPartyPublicKey_$chatId');
    if (publicKeyJson != null) {
      return RSAService.transformMapToRSAPublicKey(
        (jsonDecode(publicKeyJson) as Map<String, dynamic>).cast(),
      );
    }
    return null;
  }

  static const _migrationStatusKey = 'key_migration_status';
  static const _migrationChatIdsKey = 'key_migration_chat_ids';
  static const _staged = 'staged';
  static const _committed = 'committed';

  Future<void> reencryptAllKeys({
    required List<String> chatIds,
    required String oldPassword,
    required String newPassword,
  }) async {
    await _secureStorage.write(
      key: _migrationChatIdsKey,
      value: chatIds.join(','),
    );

    for (final chatId in chatIds) {
      await _stageReencryptedKey(
        storageKeyPrefix: 'privateKey',
        chatId: chatId,
        oldPassword: oldPassword,
        newPassword: newPassword,
        allowLegacyPlainJson: true,
      );
      await _stageReencryptedKey(
        storageKeyPrefix: 'symmetricKey',
        chatId: chatId,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    }

    await _secureStorage.write(key: _migrationStatusKey, value: _staged);
    await _commitStagedKeys(chatIds);
    await _cleanupStagedKeys(chatIds);
  }

  Future<void> _stageReencryptedKey({
    required String storageKeyPrefix,
    required String chatId,
    required String oldPassword,
    required String newPassword,
    bool allowLegacyPlainJson = false,
  }) async {
    final raw = await _secureStorage.read(key: '${storageKeyPrefix}_$chatId');
    if (raw == null) return;

    final Uint8List plaintext;
    if (allowLegacyPlainJson && raw.startsWith('{')) {
      plaintext = Uint8List.fromList(utf8.encode(raw));
    } else {
      plaintext = await PasswordBasedEncryptionSevice.decrypt(
          base64Decode(raw), oldPassword);
    }

    final reencrypted =
        await PasswordBasedEncryptionSevice.encrypt(plaintext, newPassword);
    await _secureStorage.write(
      key: 'staged_${storageKeyPrefix}_$chatId',
      value: base64Encode(reencrypted),
    );
  }

  Future<void> recoverStagedMigration() async {
    final status = await _secureStorage.read(key: _migrationStatusKey);
    if (status == null) return;

    final chatIdsRaw = await _secureStorage.read(key: _migrationChatIdsKey);
    if (chatIdsRaw == null || chatIdsRaw.isEmpty) {
      await _secureStorage.delete(key: _migrationStatusKey);
      return;
    }
    final chatIds = chatIdsRaw.split(',');

    if (status == _staged) {
      await _commitStagedKeys(chatIds);
      await _cleanupStagedKeys(chatIds);
    } else if (status == _committed) {
      await _cleanupStagedKeys(chatIds);
    }
  }

  Future<void> _commitStagedKeys(List<String> chatIds) async {
    for (final chatId in chatIds) {
      final stagedPrivate =
          await _secureStorage.read(key: 'staged_privateKey_$chatId');
      if (stagedPrivate != null) {
        await _secureStorage.write(
            key: 'privateKey_$chatId', value: stagedPrivate);
      }

      final stagedSymmetric =
          await _secureStorage.read(key: 'staged_symmetricKey_$chatId');
      if (stagedSymmetric != null) {
        await _secureStorage.write(
            key: 'symmetricKey_$chatId', value: stagedSymmetric);
      }
    }

    await _secureStorage.write(key: _migrationStatusKey, value: _committed);
  }

  Future<void> _cleanupStagedKeys(List<String> chatIds) async {
    for (final chatId in chatIds) {
      await _secureStorage.delete(key: 'staged_privateKey_$chatId');
      await _secureStorage.delete(key: 'staged_symmetricKey_$chatId');
    }
    await _secureStorage.delete(key: _migrationStatusKey);
    await _secureStorage.delete(key: _migrationChatIdsKey);
  }

  Future<void> clearAllKeysForChat(String chatId) async {
    await _secureStorage.delete(key: 'privateKey_$chatId');
    await _secureStorage.delete(key: 'publicKey_$chatId');
    await _secureStorage.delete(key: 'symmetricKey_$chatId');
    await _secureStorage.delete(key: 'otherPartyPublicKey_$chatId');
  }
}
