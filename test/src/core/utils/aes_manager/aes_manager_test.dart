import 'dart:convert';
import 'dart:typed_data';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/api.dart';
import 'package:test/test.dart';

void main() {
  group('AESManager Tests', () {
    late Uint8List key;
    late Uint8List plaintext;

    setUp(() async {
      key = await AESManager.generateKey();
      plaintext = utf8.encode('This is a secret message!');
    });

    test('Basic encryption/decryption with AES GCM', () async {
      final encrypted = await AESManager.encrypt(plaintext, key);
      expect(encrypted, isNotEmpty);

      final decrypted = await AESManager.decrypt(encrypted, key);
      expect(decrypted, equals(plaintext));
    });

    test('String encryption/decryption with AES GCM', () async {
      const plainTextStr = 'Hello, AES Encryption!';
      final encStr = await AESManager.encryptText(plainTextStr, key);
      expect(encStr, isNotEmpty);

      final decStr = await AESManager.decryptText(encStr, key);
      expect(decStr, equals(plainTextStr));
    });

    test('Tampered ciphertext should fail on decryption', () async {
      final enc = await AESManager.encrypt(plaintext, key);

      // Tamper with one byte
      enc[10] = enc[10] ^ 0xFF;

      expect(
        () async => await AESManager.decrypt(enc, key),
        throwsA(isA<InvalidCipherTextException>()),
      );
    });

    test('Incorrect key should fail to decrypt', () async {
      final enc = await AESManager.encrypt(plaintext, key);
      final wrongKey = await AESManager.generateKey();

      expect(
        () async => await AESManager.decrypt(enc, wrongKey),
        throwsA(anything),
      );
    });

    test('Ensure AES key length is correct (256 bits)', () {
      expect(key.length, equals(32));
    });

    test('Performance test: Large data encryption/decryption', () async {
      // Generate large random data (e.g. 5MB)
      final largeData = Uint8List.fromList(List<int>.generate(5 * 1024 * 1024, (i) => i % 256));
      final enc = await AESManager.encrypt(largeData, key);
      expect(enc, isNotEmpty);

      final dec = await AESManager.decrypt(enc, key);
      expect(dec, equals(largeData));
    });

    test('AES with empty plaintext', () async {
      final empty = Uint8List.fromList([]);

      final enc = await AESManager.encrypt(empty, key);
      expect(enc, isNotEmpty);

      final dec = await AESManager.decrypt(enc, key);
      expect(dec, equals(empty));
    });

    test('AES with invalid key size should fail', () async {
      final wrongKey = Uint8List(52);
      final testData = utf8.encode('Test');

      expect(
        () async => await AESManager.encrypt(testData, wrongKey),
        throwsA(anything),
      );
    });

    test('Short tampered ciphertext', () async {
      final enc = await AESManager.encrypt(plaintext, key);
      // Keep only the nonce portion
      final shortEnc = enc.sublist(0, 12);

      expect(
        () async => await AESManager.decrypt(shortEnc, key),
        throwsA(anything),
      );
    });
  });
}
