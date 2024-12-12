import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

import '../secure_bytes_generation.dart';

part 'password_based_encryption_manager_impl.dart';

class PasswordBasedEncryptionManager {
  static Future<Uint8List> encrypt(Uint8List bytes, String password) async {
    return Isolate.run(() => _PasswordBasedEncryptionManagerImpl.syncEncrypt(bytes, password));
  }

  static Future<Uint8List> decrypt(Uint8List encryptedBytes, String password) async {
    return Isolate.run(() => _PasswordBasedEncryptionManagerImpl.syncDecrypt(encryptedBytes, password));
  }
}
