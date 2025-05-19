import 'dart:typed_data';
import 'package:fuzzy_chat/src/core/core.dart' show AESServiceDebugExpose;

class AESManagerTestHooks {
  static Uint8List deriveEphemeral({
    required Uint8List mainKey,
    required Uint8List salt,
  }) =>
      AESServiceDebugExpose.deriveEphemeralKey(
        mainKey: mainKey,
        salt: salt,
      );

  static Uint8List encryptWithFixedSaltNonce(
    Uint8List plaintext,
    Uint8List key,
    Uint8List salt,
    Uint8List nonce,
  ) =>
      AESServiceDebugExpose.encryptWithFixedSaltNonce(
        plaintext: plaintext,
        key: key,
        salt: salt,
        nonce: nonce,
      );
}
