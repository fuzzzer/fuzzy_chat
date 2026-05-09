import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fuzzy_chat/lib.dart';

class VaultCryptoRepository {
  const VaultCryptoRepository({
    required this.passwordStrengthService,
  });

  final PasswordStrengthService passwordStrengthService;

  Future<VaultResponse<VaultMetadata>> initializeVault(String password) async {
    try {
      final strength = passwordStrengthService.assess(password);
      if (strength.level == PasswordStrengthLevel.weak) {
        return const VaultFailure(VaultFailureType.weakPassword);
      }

      final salt = generateRandomSecureBytes(24);
      final masterKey = await PasswordBasedEncryptionSevice.deriveKey(password, salt);

      final verificationTokenBytes = generateRandomSecureBytes(32);
      final encryptedToken = await AESService.encrypt(verificationTokenBytes, masterKey);

      final metadata = VaultMetadata(
        vaultId: generateId(),
        verificationToken: base64Encode(encryptedToken),
        masterSalt: base64Encode(salt),
        createdAt: DateTime.now(),
        lastUnlockedAt: DateTime.now(),
        autoLockMinutes: 5,
      );

      return VaultSuccess(metadata);
    } catch (e) {
      return VaultFailure(VaultFailureType.unknown, message: e.toString());
    }
  }

  Future<VaultResponse<Uint8List>> verifyAndDeriveKey(String password, VaultMetadata metadata) async {
    try {
      final salt = base64Decode(metadata.masterSalt);
      final masterKey = await PasswordBasedEncryptionSevice.deriveKey(password, salt);

      final encryptedToken = base64Decode(metadata.verificationToken);
      try {
        await AESService.decrypt(encryptedToken, masterKey);
        return VaultSuccess(masterKey);
      } catch (_) {
        return const VaultFailure(VaultFailureType.incorrectMasterPassword);
      }
    } catch (e) {
      return VaultFailure(VaultFailureType.unknown, message: e.toString());
    }
  }

  Future<VaultResponse<Uint8List>> encryptContent(
    dynamic content,
    Uint8List masterKey, {
    String? customPassword,
  }) async {
    try {
      Uint8List bytesToEncrypt;

      if (content is VaultPasswordContent) {
        bytesToEncrypt = utf8.encode(jsonEncode(content.toJson()));
      } else if (content is VaultNoteContent) {
        bytesToEncrypt = utf8.encode(jsonEncode(content.toJson()));
      } else {
        return const VaultFailure(VaultFailureType.unknown, message: 'Unsupported content type');
      }

      Uint8List encryptedBytes = await AESService.encrypt(bytesToEncrypt, masterKey);

      if (customPassword != null && customPassword.isNotEmpty) {
        encryptedBytes = await PasswordBasedEncryptionSevice.encrypt(encryptedBytes, customPassword);
      }

      return VaultSuccess(encryptedBytes);
    } catch (e) {
      return VaultFailure(VaultFailureType.unknown, message: e.toString());
    }
  }

  Future<VaultResponse<dynamic>> decryptContent(
    Uint8List encryptedBytes,
    Uint8List masterKey,
    VaultItemType type, {
    String? customPassword,
  }) async {
    try {
      Uint8List bytesToDecrypt = encryptedBytes;

      if (customPassword != null && customPassword.isNotEmpty) {
        try {
          bytesToDecrypt = await PasswordBasedEncryptionSevice.decrypt(bytesToDecrypt, customPassword);
        } catch (_) {
          return const VaultFailure(VaultFailureType.incorrectCustomPassword);
        }
      }

      Uint8List decryptedBytes;
      try {
        decryptedBytes = await AESService.decrypt(bytesToDecrypt, masterKey);
      } catch (_) {
        return const VaultFailure(VaultFailureType.decryptionFailed);
      }

      final jsonString = utf8.decode(decryptedBytes);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

      if (type == VaultItemType.password) {
        return VaultSuccess(VaultPasswordContent.fromJson(jsonMap));
      } else if (type == VaultItemType.note) {
        return VaultSuccess(VaultNoteContent.fromJson(jsonMap));
      } else {
        return const VaultFailure(VaultFailureType.unknown, message: 'Unsupported content type');
      }
    } catch (e) {
      return VaultFailure(VaultFailureType.unknown, message: e.toString());
    }
  }

  Future<VaultResponse<Map<String, Uint8List>>> reencryptAll(
    Map<String, Uint8List> items,
    Uint8List oldKey,
    Uint8List newKey,
  ) async {
    try {
      final newItems = <String, Uint8List>{};
      for (final entry in items.entries) {
        final decryptedBytes = await AESService.decrypt(entry.value, oldKey);
        final newEncryptedBytes = await AESService.encrypt(decryptedBytes, newKey);
        newItems[entry.key] = newEncryptedBytes;
      }
      return VaultSuccess(newItems);
    } catch (e) {
      return VaultFailure(VaultFailureType.unknown, message: e.toString());
    }
  }
}
