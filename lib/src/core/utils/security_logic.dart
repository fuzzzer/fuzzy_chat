import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';

class RSAManager {
  static final _publicExponent = BigInt.from(65537);
  static const _bitStrength = 4096;
  // certainty minimizes the probability that chosen numbers p,q for key construction will not be prime
  // probability that chosen numbers will be weak(nonprime) is 1 / (2^certainty), so any number after 100 will give us preeeetty good confidence.
  // for example for certainty 100 the chance that algorithm messes up is 1 / (2^100) ≈ (can )
  static const _certainty = 100;

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
    final keyParams = RSAKeyGeneratorParameters(_publicExponent, _bitStrength, _certainty);

    final keyGenerator = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          keyParams,
          generateSecureRandom(),
        ),
      );

    final keyPair = keyGenerator.generateKeyPair();
    final publicKey = keyPair.publicKey as RSAPublicKey;
    final privateKey = keyPair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair(publicKey, privateKey);
  }

  static SecureRandom generateSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = List<int>.generate(32, (index) => seedSource.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  static String encrypt(String value, RSAPublicKey publicKey) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(
        true,
        PublicKeyParameter<RSAPublicKey>(publicKey),
      );

    final encrypted = encryptor.process(Uint8List.fromList(value.codeUnits));

    return base64.encode(encrypted);
  }

  static String decrypt(String encryptedValue, RSAPrivateKey privateKey) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(
        false,
        PrivateKeyParameter<RSAPrivateKey>(privateKey),
      );

    final decrypted = decryptor.process(base64.decode(encryptedValue));

    return String.fromCharCodes(decrypted);
  }

  static Uint8List sign(Uint8List value, RSAPrivateKey privateKey) {
    final signer = RSASigner(SHA256Digest(), _sha256DigestIdentifierHex)
      ..init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    final signature = signer.generateSignature(value);
    return signature.bytes;
  }

  static bool verify(Uint8List value, Uint8List signature, RSAPublicKey publicKey) {
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

  static Map<String, dynamic> transformRSAPublicKeyToMap(RSAPublicKey publicKey) {
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

  static Future<void> saveKeyToFile(String key, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    await file.writeAsString(key);
  }

  static Future<String> loadKeyFromFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    final file = File(path);
    return file.readAsString();
  }

  static Future<void> savePrivateKeyToFile(RSAPrivateKey privateKey, String fileName) async {
    final privateKeyMap = transformRSAPrivateKeyToMap(privateKey);
    final privateKeyJson = json.encode(privateKeyMap);
    await saveKeyToFile(privateKeyJson, fileName);
  }

  static Future<void> savePublicKeyToFile(RSAPublicKey publicKey, String fileName) async {
    final publicKeyMap = transformRSAPublicKeyToMap(publicKey);
    final publicKeyJson = json.encode(publicKeyMap);
    await saveKeyToFile(publicKeyJson, fileName);
  }

  static Future<RSAPrivateKey> loadPrivateKeyFromFile(String fileName) async {
    final privateKeyJson = await loadKeyFromFile(fileName);
    final privateKeyMap = castMapToAllStringMap(json.decode(privateKeyJson) as Map<String, dynamic>);

    return transformMapToRSAPrivateKey(privateKeyMap);
  }

  static Future<RSAPublicKey> loadPublicKeyFromFile(String fileName) async {
    final publicKeyJson = await loadKeyFromFile(fileName);
    final publicKeyMap = castMapToAllStringMap(json.decode(publicKeyJson) as Map<String, dynamic>);

    return transformMapToRSAPublicKey(publicKeyMap);
  }
}

Map<String, String> castMapToAllStringMap(Map<String, dynamic> map) {
  return map.map((key, value) => MapEntry(key, value.toString()));
}
