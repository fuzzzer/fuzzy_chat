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
      key = await AESService.generateKey();
      plaintext = utf8.encode('This is a secret message!');
    });

    test('Basic encryption/decryption with AES GCM', () async {
      final encrypted = await AESService.encrypt(plaintext, key);
      expect(encrypted, isNotEmpty);

      final decrypted = await AESService.decrypt(encrypted, key);
      expect(decrypted, equals(plaintext));
    });

    test('String encryption/decryption with AES GCM', () async {
      const plainTextStr = 'Hello, AES Encryption!';
      final encStr = await AESService.encryptText(plainTextStr, key);
      expect(encStr, isNotEmpty);

      final decStr = await AESService.decryptText(encStr, key);
      expect(decStr, equals(plainTextStr));
    });

    test('Tampered ciphertext should fail on decryption', () async {
      final enc = await AESService.encrypt(plaintext, key);

      // Tamper with one byte
      enc[10] = enc[10] ^ 0xFF;

      expect(
        () async => await AESService.decrypt(enc, key),
        throwsA(isA<InvalidCipherTextException>()),
      );
    });

    test('Incorrect key should fail to decrypt', () async {
      final enc = await AESService.encrypt(plaintext, key);
      final wrongKey = await AESService.generateKey();

      expect(
        () async => await AESService.decrypt(enc, wrongKey),
        throwsA(anything),
      );
    });

    test('Ensure AES key length is correct (256 bits)', () {
      expect(key.length, equals(32));
    });

    test('Performance test: Large data encryption/decryption', () async {
      // Generate large random data (e.g. 5MB)
      final largeData = Uint8List.fromList(List<int>.generate(5 * 1024 * 1024, (i) => i % 256));
      final enc = await AESService.encrypt(largeData, key);
      expect(enc, isNotEmpty);

      final dec = await AESService.decrypt(enc, key);
      expect(dec, equals(largeData));
    });

    test('AES with empty plaintext', () async {
      final empty = Uint8List.fromList([]);

      final enc = await AESService.encrypt(empty, key);
      expect(enc, isNotEmpty);

      final dec = await AESService.decrypt(enc, key);
      expect(dec, equals(empty));
    });

    test('AES with invalid key size should fail', () async {
      final wrongKey = Uint8List(52);
      final testData = utf8.encode('Test');

      expect(
        () async => await AESService.encrypt(testData, wrongKey),
        throwsA(anything),
      );
    });

    test('Short tampered ciphertext', () async {
      final enc = await AESService.encrypt(plaintext, key);
      final shortEnc = enc.sublist(0, 12);

      expect(
        () async => await AESService.decrypt(shortEnc, key),
        throwsA(anything),
      );
    });

    test('Repeated encryption produces different ciphertext', () async {
      final enc1 = await AESService.encrypt(plaintext, key);
      final enc2 = await AESService.encrypt(plaintext, key);

      expect(enc1, isNot(equals(enc2)));

      final dec1 = await AESService.decrypt(enc1, key);
      final dec2 = await AESService.decrypt(enc2, key);

      expect(dec1, equals(plaintext));
      expect(dec2, equals(plaintext));
    });
  });
}
