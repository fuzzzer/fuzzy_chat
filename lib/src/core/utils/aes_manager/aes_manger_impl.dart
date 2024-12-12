part of 'aes_manager.dart';

class _AESManagerImpl {
  static const _nonceByteLength = 12;
  static const _keyByteLength = 32;

  static const macSize = 128;

  static Uint8List generateKey() {
    return generateRandomSecureBytes(_keyByteLength);
  }

  static Uint8List syncEncrypt(Uint8List inputBytes, Uint8List key) {
    final nonce = generateRandomSecureBytes(_nonceByteLength);

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);

    final encryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(ephemeralKey),
          macSize,
          nonce,
          Uint8List(0),
        ),
      );

    final encryptedData = encryptCipher.process(inputBytes);

    final result = Uint8List.fromList(nonce + encryptedData);
    return result;
  }

  static Uint8List syncDecrypt(Uint8List encryptedInputBytes, Uint8List key) {
    final nonce = encryptedInputBytes.sublist(0, _nonceByteLength);
    final encryptedData = encryptedInputBytes.sublist(_nonceByteLength);

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);

    final decryptCipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(ephemeralKey),
          macSize,
          nonce,
          Uint8List(0),
        ),
      );

    final decryptedData = decryptCipher.process(encryptedData);
    return decryptedData;
  }

  static Uint8List _deriveEphemeralKey({
    required Uint8List mainKey,
    required Uint8List nonce,
  }) {
    final hkdf = HKDFKeyDerivator(SHA256Digest())
      ..init(
        HkdfParameters(
          mainKey,
          _keyByteLength,
          null,
          nonce,
        ),
      );

    final derived = Uint8List(_keyByteLength);
    hkdf.deriveKey(null, 0, derived, 0);
    return derived;
  }
}
