part of 'aes_manager.dart';

class _AESManagerImpl {
  static const _nonceByteLength = 12;
  static const _keyByteLength = 32;

  static const macSize = 128;

  static AESKey generateKey() {
    return AESKey(
      secretParameter: generateRandomSecureBytes(_keyByteLength),
    );
  }

  static String syncEncrypt(String text, AESKey key) {
    final nonce = generateRandomSecureBytes(_nonceByteLength);
    final encryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key.secretParameter), macSize, nonce, Uint8List(0)),
      );

    final input = Uint8List.fromList(utf8.encode(text));
    final encryptedData = encryptCipher.process(input);

    final result = Uint8List.fromList(nonce + encryptedData);
    return base64.encode(result);
  }

  static String syncDecrypt(String text, AESKey key) {
    final input = base64.decode(text);
    final nonce = input.sublist(0, _nonceByteLength);
    final encryptedData = input.sublist(_nonceByteLength);

    final decryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key.secretParameter), macSize, nonce, Uint8List(0)),
      );

    final decryptedData = decryptCipher.process(encryptedData);
    return utf8.decode(decryptedData);
  }
}
