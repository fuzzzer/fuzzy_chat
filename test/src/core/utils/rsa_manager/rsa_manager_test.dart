import 'dart:convert';
import 'dart:typed_data';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:test/test.dart';

void main() {
  group('RSAManager Tests', () {
    late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;
    late Uint8List plaintext;
    late Uint8List encrypted;

    setUp(() async {
      keyPair = await RSAManager.generateRSAKeyPair();
      plaintext = utf8.encode('RSA test message');
    });

    test('RSA Key Pair Generation', () {
      expect(keyPair.publicKey, isA<RSAPublicKey>());
      expect(keyPair.privateKey, isA<RSAPrivateKey>());
    });

    test('RSA Encryption/Decryption', () async {
      encrypted = await RSAManager.encrypt(plaintext, keyPair.publicKey);
      expect(encrypted, isNotEmpty);

      final decrypted = await RSAManager.decrypt(encrypted, keyPair.privateKey);
      expect(decrypted, equals(plaintext));
    });

    test('RSA Decryption with wrong key fails', () async {
      final otherKeyPair = await RSAManager.generateRSAKeyPair();
      encrypted = await RSAManager.encrypt(plaintext, keyPair.publicKey);

      expect(
        () async => await RSAManager.decrypt(encrypted, otherKeyPair.privateKey),
        throwsA(anything),
      );
    });

    test('RSA Sign/Verify', () async {
      final signature = await RSAManager.sign(plaintext, keyPair.privateKey);
      expect(signature, isNotEmpty);

      final isValid = await RSAManager.verify(plaintext, signature, keyPair.publicKey);
      expect(isValid, isTrue);
    });

    test('RSA Verify fails with modified signature', () async {
      final signature = await RSAManager.sign(plaintext, keyPair.privateKey);
      signature[0] = signature[0] ^ 0xFF;

      final isValid = await RSAManager.verify(plaintext, signature, keyPair.publicKey);
      expect(isValid, isFalse);
    });

    test('Transform keys to map and back', () {
      final privateKeyMap = RSAManager.transformRSAPrivateKeyToMap(keyPair.privateKey);
      final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(keyPair.publicKey);

      final restoredPrivateKey = RSAManager.transformMapToRSAPrivateKey(privateKeyMap);
      final restoredPublicKey = RSAManager.transformMapToRSAPublicKey(publicKeyMap);

      expect(restoredPrivateKey.n, equals(keyPair.privateKey.n));
      expect(restoredPrivateKey.privateExponent, equals(keyPair.privateKey.privateExponent));
      expect(restoredPublicKey.n, equals(keyPair.publicKey.n));
      expect(restoredPublicKey.publicExponent, equals(keyPair.publicKey.publicExponent));
    });

    test('RSA with empty plaintext', () async {
      final empty = Uint8List.fromList([]);

      final enc = await RSAManager.encrypt(empty, keyPair.publicKey);
      final dec = await RSAManager.decrypt(enc, keyPair.privateKey);

      expect(dec, equals(empty));
    });
  });
}
