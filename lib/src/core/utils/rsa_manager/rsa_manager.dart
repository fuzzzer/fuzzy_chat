import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

part 'rsa_manger_impl.dart';

class RSAManager {
  static Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>> generateRSAKeyPair() {
    return Isolate.run(_RSAManagerImpl.generateRSAKeyPairSync);
  }

  static Future<String> encrypt(String value, RSAPublicKey publicKey) {
    return Isolate.run(() => _RSAManagerImpl.syncEncrypt(value, publicKey));
  }

  static Future<String> decrypt(String encryptedValue, RSAPrivateKey privateKey) {
    return Isolate.run(() => _RSAManagerImpl.syncDecrypt(encryptedValue, privateKey));
  }

  static Future<Uint8List> sign(Uint8List value, RSAPrivateKey privateKey) {
    return Isolate.run(() => _RSAManagerImpl.syncSign(value, privateKey));
  }

  static Future<bool> verify(Uint8List value, Uint8List signature, RSAPublicKey publicKey) {
    return Isolate.run(() => _RSAManagerImpl.syncVerify(value, signature, publicKey));
  }

  static Map<String, String> transformRSAPrivateKeyToMap(RSAPrivateKey privateKey) {
    return _RSAManagerImpl.transformRSAPrivateKeyToMap(privateKey);
  }

  static RSAPrivateKey transformMapToRSAPrivateKey(Map<String, String> map) {
    return _RSAManagerImpl.transformMapToRSAPrivateKey(map);
  }

  static Map<String, dynamic> transformRSAPublicKeyToMap(RSAPublicKey publicKey) {
    return _RSAManagerImpl.transformRSAPublicKeyToMap(publicKey);
  }

  static RSAPublicKey transformMapToRSAPublicKey(Map<String, String> map) {
    return _RSAManagerImpl.transformMapToRSAPublicKey(map);
  }
}
