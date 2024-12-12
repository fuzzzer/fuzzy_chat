import 'dart:convert';
import 'dart:typed_data';
import 'package:fuzzy_chat/lib.dart';
import 'package:test/test.dart';

void main() {
  group('PasswordBasedEncryptionManager Tests', () {
    const password = 'StrongPassword123!';
    late Uint8List plaintext;
    late Uint8List encrypted;

    setUp(() {
      plaintext = utf8.encode('Sensitive data protected by password.');
    });

    test('Basic password-based encryption/decryption', () async {
      encrypted = await PasswordBasedEncryptionManager.encrypt(plaintext, password);
      expect(encrypted, isNotEmpty);

      final decrypted = await PasswordBasedEncryptionManager.decrypt(encrypted, password);
      expect(decrypted, equals(plaintext));
    });

    test('Incorrect password should fail to decrypt', () async {
      encrypted = await PasswordBasedEncryptionManager.encrypt(plaintext, password);
      expect(
        () async => await PasswordBasedEncryptionManager.decrypt(encrypted, 'WrongPassword'),
        throwsA(anything),
      );
    });

    test('Tampering with encrypted bytes leads to failure', () async {
      encrypted = await PasswordBasedEncryptionManager.encrypt(plaintext, password);
      encrypted[20] = encrypted[20] ^ 0xAA;

      expect(
        () async => await PasswordBasedEncryptionManager.decrypt(encrypted, password),
        throwsA(anything),
      );
    });

    test('Password-based encryption with empty plaintext', () async {
      final empty = Uint8List.fromList([]);
      final enc = await PasswordBasedEncryptionManager.encrypt(empty, password);
      final dec = await PasswordBasedEncryptionManager.decrypt(enc, password);

      expect(dec, equals(empty));
    });
  });
}
