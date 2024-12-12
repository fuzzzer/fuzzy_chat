part of 'password_based_encryption_manager.dart';

class _PasswordBasedEncryptionManagerImpl {
  static const _saltByteLength = 16;
  static const _nonceByteLength = 12;

  static const macSize = 128;

  static Uint8List syncEncrypt(Uint8List inputBytes, String password) {
    final salt = generateRandomSecureBytes(_saltByteLength);
    final key = deriveKey(password, salt);
    final nonce = generateRandomSecureBytes(_nonceByteLength);

    final encryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(KeyParameter(key), macSize, nonce, Uint8List(0)),
      );

    final encryptedData = encryptCipher.process(inputBytes);

    final result = Uint8List.fromList(salt + nonce + encryptedData);
    return result;
  }

  static Uint8List syncDecrypt(Uint8List encryptedInputBytes, String password) {
    final salt = encryptedInputBytes.sublist(0, _saltByteLength);
    final nonce = encryptedInputBytes.sublist(_saltByteLength, _saltByteLength + _nonceByteLength);
    final encryptedData = encryptedInputBytes.sublist(_saltByteLength + _nonceByteLength);

    final key = deriveKey(password, salt);

    final decryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(KeyParameter(key), macSize, nonce, Uint8List(0)),
      );

    final decryptedData = decryptCipher.process(encryptedData);
    return decryptedData;
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
