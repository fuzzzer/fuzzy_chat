import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import '../secure_bytes_generation.dart';

part 'aes_manger_impl.dart';

class AESManager {
  static Future<String> encrypt(String text, Uint8List key) async {
    return Isolate.run(() => _AESManagerImpl.syncEncrypt(text, key));
  }

  static Future<String> decrypt(String encryptedText, Uint8List key) async {
    return Isolate.run(() => _AESManagerImpl.syncDecrypt(encryptedText, key));
  }

  static Future<Uint8List> generateKey() async {
    return Isolate.run(_AESManagerImpl.generateKey);
  }
}
