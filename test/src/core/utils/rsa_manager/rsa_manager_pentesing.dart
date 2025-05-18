import 'dart:math';
import 'dart:typed_data';

import 'package:fuzzy_chat/src/core/core.dart';
import 'package:pointycastle/export.dart';
import 'package:test/test.dart';

Uint8List _randomBytes(int length) =>
    Uint8List.fromList(List<int>.generate(length, (_) => Random.secure().nextInt(256)));

int _maxOaepLen(RSAPublicKey k, {int hashLen = 20 /* SHA‑1 default */}) {
  final keyBytes = (k.modulus!.bitLength + 7) >> 3;
  return keyBytes - 2 * hashLen - 2;
}

void main() {
  group('RSAManager – Key Generation', () {
    late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;

    setUpAll(() async {
      keyPair = await RSAManager.generateRSAKeyPair();
    });

    test('generates 4096‑bit modulus', () {
      expect(keyPair.publicKey.n!.bitLength, equals(4096));
    });

    test('uses public exponent 65537', () {
      expect(keyPair.publicKey.publicExponent, equals(BigInt.from(65537)));
    });

    test('p and q pass small‑prime screen (quick sanity)', () {
      final p = keyPair.privateKey.p!;
      final q = keyPair.privateKey.q!;
      expect(_passesSmallPrimeTest(p), isTrue);
      expect(_passesSmallPrimeTest(q), isTrue);
    });

    test('gcd(e, φ(n)) == 1', () {
      final e = keyPair.publicKey.publicExponent;
      final phi = (keyPair.privateKey.p! - BigInt.one) * (keyPair.privateKey.q! - BigInt.one);
      expect(e?.gcd(phi), equals(BigInt.one));
    });
  });

  test('cross‑key isolation (decrypt/verify with wrong key fails)', () async {
    final kp1 = await RSAManager.generateRSAKeyPair();
    final kp2 = await RSAManager.generateRSAKeyPair();

    // Encryption/decryption mismatch
    final msg = _randomBytes(42);
    final ct = await RSAManager.encrypt(msg, kp1.publicKey);

    expect(
      () async => await RSAManager.decrypt(ct, kp2.privateKey),
      throwsA(isA<ArgumentError>()),
    );

    final sig = await RSAManager.sign(msg, kp1.privateKey);
    final ok = await RSAManager.verify(msg, sig, kp2.publicKey);
    expect(ok, isFalse);
  });

  group('RSAManager – Encryption/Decryption', () {
    late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;
    late RSAPublicKey pub;
    late RSAPrivateKey priv;

    setUpAll(() async {
      keyPair = await RSAManager.generateRSAKeyPair();
      pub = keyPair.publicKey;
      priv = keyPair.privateKey;
    });

    test('round‑trip for various message lengths', () async {
      final max = _maxOaepLen(pub);
      for (final len in [1, 64, 128, max - 1, max]) {
        final msg = _randomBytes(len);
        final ct = await RSAManager.encrypt(msg, pub);
        final pt = await RSAManager.decrypt(ct, priv);
        expect(pt, equals(msg));
      }
    });

    test('encrypting message longer than OAEP limit throws', () async {
      final tooLong = _randomBytes(_maxOaepLen(pub) + 1);
      expect(() => RSAManager.encrypt(tooLong, pub), throwsA(isA<ArgumentError>()));
    });

    test('tampered ciphertext fails to decrypt', () async {
      final msg = _randomBytes(64);
      final ct = await RSAManager.encrypt(msg, pub);
      ct[ct.length - 1] ^= 0x01;

      expect(
        () async => await RSAManager.decrypt(ct, priv),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('identical plaintext encrypts to different ciphertexts (OAEP randomness)', () async {
      final msg = _randomBytes(32);
      final ct1 = await RSAManager.encrypt(msg, pub);
      final ct2 = await RSAManager.encrypt(msg, pub);
      expect(ct1, isNot(equals(ct2)));
    });
  });

  group('RSAManager – Sign/Verify', () {
    late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;
    late RSAPublicKey pub;
    late RSAPrivateKey priv;

    setUpAll(() async {
      keyPair = await RSAManager.generateRSAKeyPair();
      pub = keyPair.publicKey;
      priv = keyPair.privateKey;
    });

    test('valid signature verifies', () async {
      final msg = _randomBytes(128);
      final sig = await RSAManager.sign(msg, priv);
      final ok = await RSAManager.verify(msg, sig, pub);
      expect(ok, isTrue);
    });

    test('message alteration invalidates signature', () async {
      final msg = _randomBytes(128);
      final sig = await RSAManager.sign(msg, priv);
      msg[0] ^= 0x01;
      final ok = await RSAManager.verify(msg, sig, pub);
      expect(ok, isFalse);
    });

    test('tampered signature fails verification', () async {
      final msg = _randomBytes(128);
      final sig = await RSAManager.sign(msg, priv);
      sig[sig.length - 1] ^= 0x01;
      final ok = await RSAManager.verify(msg, sig, pub);
      expect(ok, isFalse);
    });
  });

  group('RSAManager – Key (De)Serialisation', () {
    late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;

    setUpAll(() async {
      keyPair = await RSAManager.generateRSAKeyPair();
    });

    test('private key map round‑trips', () {
      final m = RSAManager.transformRSAPrivateKeyToMap(keyPair.privateKey);
      final rebuilt = RSAManager.transformMapToRSAPrivateKey(m);
      expect(rebuilt.n, equals(keyPair.privateKey.n));
      expect(rebuilt.privateExponent, equals(keyPair.privateKey.privateExponent));
    });

    test('public key map round‑trips', () {
      final m = RSAManager.transformRSAPublicKeyToMap(keyPair.publicKey);
      final rebuilt = RSAManager.transformMapToRSAPublicKey(m);
      expect(rebuilt.n, equals(keyPair.publicKey.n));
      expect(rebuilt.publicExponent, equals(keyPair.publicKey.publicExponent));
    });
  });

  group('RSAManager – Concurrency', () {
    test('parallel isolates round‑trip correctly', () async {
      final keyPair = await RSAManager.generateRSAKeyPair();
      final pub = keyPair.publicKey;
      final priv = keyPair.privateKey;

      await Future.wait(
        List.generate(8, (_) async {
          final msg = _randomBytes(48);
          final ct = await RSAManager.encrypt(msg, pub);
          final pt = await RSAManager.decrypt(ct, priv);
          expect(pt, equals(msg));
        }),
      );
    });
  });
  group('RSAManager – Advanced & Negative Scenarios', () {
    test('random ciphertext (same length as modulus) fails to decrypt', () async {
      final keyPair = await RSAManager.generateRSAKeyPair();
      final priv = keyPair.privateKey;
      final modulusBytes = (priv.n!.bitLength + 7) >> 3;
      final junk = _randomBytes(modulusBytes);

      expect(
        () async => await RSAManager.decrypt(junk, priv),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('multiple key pairs have unique moduli', () async {
      final pairs = await Future.wait(List.generate(5, (_) => RSAManager.generateRSAKeyPair()));
      final moduli = pairs.map((kp) => kp.publicKey.n).toSet();
      expect(moduli.length, equals(5));
    });

    test('signing is deterministic with same key & message', () async {
      final kp = await RSAManager.generateRSAKeyPair();
      final msg = _randomBytes(64);
      final s1 = await RSAManager.sign(msg, kp.privateKey);
      final s2 = await RSAManager.sign(msg, kp.privateKey);
      expect(s1, equals(s2));
    });

    test('modulus bit‑flip during serialisation breaks decrypt', () async {
      bool runsSuccessfully = false;
      try {
        final kp = await RSAManager.generateRSAKeyPair();
        final privMap = RSAManager.transformRSAPrivateKeyToMap(kp.privateKey);
        // Flip least‑significant bit of modulus string
        final modStr = privMap['modulus']!;
        final flipped = (BigInt.parse(modStr) ^ BigInt.one).toString();
        privMap['modulus'] = flipped;
        final badPriv = RSAManager.transformMapToRSAPrivateKey(privMap);

        final msg = _randomBytes(32);
        final ct = await RSAManager.encrypt(msg, kp.publicKey);

        await RSAManager.decrypt(ct, badPriv);
        runsSuccessfully = true;
      } catch (_) {}

      expect(runsSuccessfully, false, reason: 'Decription should not have happened we used incorrect ranodm key');
    });
  });
}

/// Quick "obviously not composite" screen: rejects if divisible by any small prime ≤ 997.
bool _passesSmallPrimeTest(BigInt n) {
  const smallPrimes = [
    3,
    5,
    7,
    11,
    13,
    17,
    19,
    23,
    29,
    31,
    37,
    41,
    43,
    47,
    53,
    59,
    61,
    67,
    71,
    73,
    79,
    83,
    89,
    97,
    101,
    103,
    107,
    109,
    113,
    127,
    131,
    137,
    139,
    149,
    151,
    157,
    163,
    167,
    173,
    179,
    181,
    191,
    193,
    197,
    199,
    211,
    223,
    227,
    229,
    233,
    239,
    241,
    251,
    257,
    263,
    269,
    271,
    277,
    281,
    283,
    293,
    307,
    311,
    313,
    317,
    331,
    337,
    347,
    349,
    353,
    359,
    367,
    373,
    379,
    383,
    389,
    397,
    401,
    409,
    419,
    421,
    431,
    433,
    439,
    443,
    449,
    457,
    461,
    463,
    467,
    479,
    487,
    491,
    499,
    503,
    509,
    521,
    523,
    541,
    547,
    557,
    563,
    569,
    571,
    577,
    587,
    593,
    599,
    601,
    607,
    613,
    617,
    619,
    631,
    641,
    643,
    647,
    653,
    659,
    661,
    673,
    677,
    683,
    691,
    701,
    709,
    719,
    727,
    733,
    739,
    743,
    751,
    757,
    761,
    769,
    773,
    787,
    797,
    809,
    811,
    821,
    823,
    827,
    829,
    839,
    853,
    857,
    859,
    863,
    877,
    881,
    883,
    887,
    907,
    911,
    919,
    929,
    937,
    941,
    947,
    953,
    967,
    971,
    977,
    983,
    991,
    997,
  ];
  for (final p in smallPrimes) {
    if (n % BigInt.from(p) == BigInt.zero) return false;
  }
  return true;
}
