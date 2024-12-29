import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/export.dart';

export 'components/components.dart';

part 'aes_manger_impl.dart';

class AESManager {
  static Future<Uint8List> encrypt(Uint8List bytes, Uint8List key) async =>
      Isolate.run(() => _AESManagerImpl.syncEncrypt(bytes, key));

  static Future<Uint8List> decrypt(Uint8List encryptedBytes, Uint8List key) async =>
      Isolate.run(() => _AESManagerImpl.syncDecrypt(encryptedBytes, key));

  static Future<String> encryptText(String text, Uint8List key) async {
    final decryptedTextBytes = utf8.encode(text);
    final encryptedTextBytes = await encrypt(decryptedTextBytes, key);
    return base64Encode(encryptedTextBytes);
  }

  static Future<String> decryptText(String base64EncryptedText, Uint8List key) async {
    final encryptedTextBytes = base64Decode(base64EncryptedText);
    final decryptedTextBytes = await decrypt(encryptedTextBytes, key);
    return utf8.decode(decryptedTextBytes);
  }

  static Future<Uint8List> generateKey() async => Isolate.run(_AESManagerImpl.generateKey);

  static Future<FileProcessingHandler> encryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async =>
      _AESManagerImpl.encryptFile(
        inputPath: inputPath,
        outputPath: outputPath,
        key: key,
      );

  static Future<FileProcessingHandler> decryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async =>
      _AESManagerImpl.decryptFile(
        inputPath: inputPath,
        outputPath: outputPath,
        key: key,
      );
}
