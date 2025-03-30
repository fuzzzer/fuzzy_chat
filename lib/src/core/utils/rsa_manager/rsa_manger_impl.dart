part of 'rsa_manager.dart';

class _RSAManagerImpl {
  static final _publicExponent = BigInt.from(65537);
  static const _bitStrength = 4096;
  // certainty minimizes the probability that chosen numbers p,q for key construction will not be prime
  // probability that chosen numbers will be weak(nonprime) is 1 / (2^certainty), so any number after 100 will give us preeeetty good confidence.
  // for example for certainty 100 the chance that algorithm messes up is 1 / (2^100) ≈ (can )
  static const _certainty = 100;

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPairSync() {
    final keyParams = RSAKeyGeneratorParameters(_publicExponent, _bitStrength, _certainty);

    final keyGenerator = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          keyParams,
          generateSecureRandom(),
        ),
      );

    final keyPair = keyGenerator.generateKeyPair();
    final publicKey = keyPair.publicKey;
    final privateKey = keyPair.privateKey;

    return AsymmetricKeyPair(publicKey, privateKey);
  }

  static SecureRandom generateSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = List<int>.generate(32, (index) => seedSource.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  static Uint8List syncEncrypt(Uint8List data, RSAPublicKey publicKey) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(publicKey),
      );

    final encrypted = encryptor.process(data);

    return encrypted;
  }

  static Uint8List syncDecrypt(Uint8List data, RSAPrivateKey privateKey) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(
        false,
        PrivateKeyParameter<RSAPrivateKey>(privateKey),
      );

    final decrypted = decryptor.process(data);

    return decrypted;
  }

  static Uint8List syncSign(Uint8List value, RSAPrivateKey privateKey) {
    final signer = RSASigner(SHA256Digest(), _sha256DigestIdentifierHex)
      ..init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    final signature = signer.generateSignature(value);
    return signature.bytes;
  }

  static bool syncVerify(Uint8List value, Uint8List signature, RSAPublicKey publicKey) {
    final verifier = RSASigner(SHA256Digest(), _sha256DigestIdentifierHex)
      ..init(false, PublicKeyParameter<RSAPublicKey>(publicKey));

    try {
      return verifier.verifySignature(value, RSASignature(signature));
    } catch (e) {
      return false;
    }
  }

  static const _sha256DigestIdentifierHex = '0609608648016503040201';

  static Map<String, String> transformRSAPrivateKeyToMap(RSAPrivateKey privateKey) {
    return {
      'modulus': privateKey.n.toString(),
      'privateExponent': privateKey.privateExponent.toString(),
      'p': privateKey.p.toString(),
      'q': privateKey.q.toString(),
      'publicExponent': privateKey.publicExponent.toString(),
    };
  }

  static RSAPrivateKey transformMapToRSAPrivateKey(Map<String, String> map) {
    return RSAPrivateKey(
      BigInt.parse(map['modulus']!),
      BigInt.parse(map['privateExponent']!),
      (map['p'] == '' || map['p'] == null || map['p'] == 'null') ? null : BigInt.parse(map['p']!),
      (map['q'] == '' || map['q'] == null || map['q'] == 'null') ? null : BigInt.parse(map['q']!),
    );
  }

  static Map<String, String> transformRSAPublicKeyToMap(RSAPublicKey publicKey) {
    return {
      'modulus': publicKey.n.toString(),
      'publicExponent': publicKey.publicExponent.toString(),
    };
  }

  static RSAPublicKey transformMapToRSAPublicKey(Map<String, String> map) {
    return RSAPublicKey(
      BigInt.parse(map['modulus']!),
      BigInt.parse(map['publicExponent']!),
    );
  }
}
