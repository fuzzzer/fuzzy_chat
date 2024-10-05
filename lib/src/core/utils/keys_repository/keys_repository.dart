import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';

import '../map_casting.dart';
import '../rsa_manager/rsa_manager.dart';

class KeysRepository {
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
    final privateKeyMap = RSAManager.transformRSAPrivateKeyToMap(privateKey);
    final privateKeyJson = json.encode(privateKeyMap);
    await saveKeyToFile(privateKeyJson, fileName);
  }

  static Future<void> savePublicKeyToFile(RSAPublicKey publicKey, String fileName) async {
    final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(publicKey);
    final publicKeyJson = json.encode(publicKeyMap);
    await saveKeyToFile(publicKeyJson, fileName);
  }

  static Future<RSAPrivateKey> loadPrivateKeyFromFile(String fileName) async {
    final privateKeyJson = await loadKeyFromFile(fileName);
    final privateKeyMap = castMapToAllStringMap(json.decode(privateKeyJson) as Map<String, dynamic>);

    return RSAManager.transformMapToRSAPrivateKey(privateKeyMap);
  }

  static Future<RSAPublicKey> loadPublicKeyFromFile(String fileName) async {
    final publicKeyJson = await loadKeyFromFile(fileName);
    final publicKeyMap = castMapToAllStringMap(json.decode(publicKeyJson) as Map<String, dynamic>);

    return RSAManager.transformMapToRSAPublicKey(publicKeyMap);
  }
}
