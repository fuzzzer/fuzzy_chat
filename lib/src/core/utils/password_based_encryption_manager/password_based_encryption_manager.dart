import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

import '../secure_bytes_generation.dart';

part 'password_based_encryption_manager_impl.dart';

class PasswordBasedEncryptionManager {
  static Future<String> encrypt(String text, String pin) async {
    return Isolate.run(() => _PasswordBasedEncryptionManagerImpl.syncEncrypt(text, pin));
  }

  static Future<String> decrypt(String text, String pin) async {
    return Isolate.run(() => _PasswordBasedEncryptionManagerImpl.syncDecrypt(text, pin));
  }
}
