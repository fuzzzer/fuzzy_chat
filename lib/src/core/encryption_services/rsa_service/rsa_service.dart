import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

part 'rsa_service_impl.dart';

class RSAService {
  static Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>> generateRSAKeyPair() {
    return Isolate.run(_RSAServiceImpl.generateRSAKeyPairSync);
  }

  static Future<Uint8List> encrypt(Uint8List data, RSAPublicKey publicKey) {
    return Isolate.run(() => _RSAServiceImpl.syncEncrypt(data, publicKey));
  }

  static Future<Uint8List> decrypt(Uint8List data, RSAPrivateKey privateKey) {
    return Isolate.run(() => _RSAServiceImpl.syncDecrypt(data, privateKey));
  }

  static Future<Uint8List> sign(Uint8List value, RSAPrivateKey privateKey) {
    return Isolate.run(() => _RSAServiceImpl.syncSign(value, privateKey));
  }

  static Future<bool> verify(Uint8List value, Uint8List signature, RSAPublicKey publicKey) {
    return Isolate.run(() => _RSAServiceImpl.syncVerify(value, signature, publicKey));
  }

  static Map<String, String> transformRSAPrivateKeyToMap(RSAPrivateKey privateKey) {
    return _RSAServiceImpl.transformRSAPrivateKeyToMap(privateKey);
  }

  static RSAPrivateKey transformMapToRSAPrivateKey(Map<String, String> map) {
    return _RSAServiceImpl.transformMapToRSAPrivateKey(map);
  }

  static Map<String, String> transformRSAPublicKeyToMap(RSAPublicKey publicKey) {
    return _RSAServiceImpl.transformRSAPublicKeyToMap(publicKey);
  }

  static RSAPublicKey transformMapToRSAPublicKey(Map<String, String> map) {
    return _RSAServiceImpl.transformMapToRSAPublicKey(map);
  }
}
