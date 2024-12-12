import 'dart:math';
import 'dart:typed_data';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/hkdf.dart';
import 'package:test/test.dart';

Uint8List testDeriveEphemeralKey({
  required Uint8List mainKey,
  required Uint8List nonce,
  int keyLength = 32,
}) {
  final hkdf = HKDFKeyDerivator(SHA256Digest())
    ..init(
      HkdfParameters(
        mainKey,
        keyLength,
        null,
        nonce,
      ),
    );

  final derived = Uint8List(keyLength);
  hkdf.deriveKey(null, 0, derived, 0);
  return derived;
}

void main() {
  group('Ephemeral Key Derivation Tests', () {
    late Uint8List mainKey;
    late Uint8List nonce;
    final rng = Random.secure();

    setUp(() async {
      mainKey = await AESManager.generateKey();
      nonce = generateRandomSecureBytes(12);
    });

    test('Deterministic for same mainKey and nonce', () {
      final key1 = testDeriveEphemeralKey(mainKey: mainKey, nonce: nonce);
      final key2 = testDeriveEphemeralKey(mainKey: mainKey, nonce: nonce);
      expect(key1, equals(key2), reason: 'Ephemeral keys should be identical for same input');
    });

    test('Different nonce leads to different ephemeral keys', () {
      final key1 = testDeriveEphemeralKey(mainKey: mainKey, nonce: nonce);

      final modifiedNonce = Uint8List.fromList(nonce);
      modifiedNonce[0] ^= 0xFF;

      final key2 = testDeriveEphemeralKey(mainKey: mainKey, nonce: modifiedNonce);

      expect(key1, isNot(equals(key2)), reason: 'Different nonce should lead to different ephemeral key');
    });

    test('Performance test for key derivation', () {
      // Derive 10,000 keys and measure time. This should be very fast.
      const iterations = 10000;
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < iterations; i++) {
        final randomNonce = Uint8List.fromList(List<int>.generate(12, (_) => rng.nextInt(256)));
        testDeriveEphemeralKey(mainKey: mainKey, nonce: randomNonce);
      }
      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;
      final avgTimePerKey = elapsedMs / iterations;
      print('Derived $iterations ephemeral keys in $elapsedMs ms ($avgTimePerKey ms/key)');
      expect(avgTimePerKey < 1, isTrue, reason: 'Ephemeral key derivation should be extremely fast');
    });

    test('Unique keys for random nonces (statistical check)', () {
      // Generate multiple ephemeral keys with random nonces and ensure low collision probability.
      const count = 1000;
      final keysSet = <String>{}; // store keys as hex strings for comparison

      for (var i = 0; i < count; i++) {
        final randomNonce = Uint8List.fromList(List<int>.generate(12, (_) => rng.nextInt(256)));
        final derivedKey = testDeriveEphemeralKey(mainKey: mainKey, nonce: randomNonce);
        keysSet.add(_toHex(derivedKey));
      }

      // Expect that all keys are unique (very high probability with a good RNG).
      expect(keysSet.length, equals(count), reason: 'All ephemeral keys should be unique with random nonces');
    });
  });
}

String _toHex(Uint8List bytes) {
  final sb = StringBuffer();
  for (final b in bytes) {
    sb.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return sb.toString();
}
