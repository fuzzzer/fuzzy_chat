part of 'password_based_encryption_manager.dart';

class _PasswordBasedEncryptionManagerImpl {
  static const _saltByteLength = 16;
  static const _nonceByteLength = 12;

  static const macSize = 128;

  static String syncEncrypt(String text, String password) {
    final salt = generateRandomSecureBytes(_saltByteLength);
    final key = deriveKey(password, salt);
    final nonce = generateRandomSecureBytes(_nonceByteLength);

    final encryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key), macSize, nonce, Uint8List(0)),
      );

    final input = Uint8List.fromList(utf8.encode(text));
    final encryptedData = encryptCipher.process(input);

    final result = Uint8List.fromList(salt + nonce + encryptedData);
    return base64.encode(result);
  }

  static String syncDecrypt(String encryptedText, String password) {
    final input = base64.decode(encryptedText);

    final salt = input.sublist(0, _saltByteLength);
    final nonce = input.sublist(_saltByteLength, _saltByteLength + _nonceByteLength);
    final encryptedData = input.sublist(_saltByteLength + _nonceByteLength);

    final key = deriveKey(password, salt);

    final decryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key), macSize, nonce, Uint8List(0)),
      );

    final decryptedData = decryptCipher.process(encryptedData);
    return utf8.decode(decryptedData);
  }

  static Uint8List deriveKey(String password, Uint8List salt) {
    final argon2 = Argon2BytesGenerator()
      ..init(
        Argon2Parameters(
          Argon2Parameters.ARGON2_id,
          salt,
          desiredKeyLength: 32,
          iterations: 4,
          memory: 65536,
          lanes: 4,
        ),
      );
    return argon2.process(Uint8List.fromList(utf8.encode(password)));
  }
}
