import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:fuzzy_chat/src/core/utils/secure_bytes_generation.dart';

import 'aes_key.dart';

part 'aes_manger_impl.dart';

class AESManager {
  static Future<String> encrypt(String text, AESKey key) async {
    return Isolate.run(() => _AESManagerImpl.syncEncrypt(text, key));
  }

  static Future<String> decrypt(String encryptedText, AESKey key) async {
    return Isolate.run(() => _AESManagerImpl.syncDecrypt(encryptedText, key));
  }

  static Future<AESKey> generateKey() async {
    return Isolate.run(_AESManagerImpl.generateKey);
  }
}
