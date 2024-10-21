import 'dart:typed_data';

import 'package:pointycastle/asymmetric/api.dart';

class ReceivedAcceptance {
  final String chatId;
  final RSAPublicKey publicKey;
  final Uint8List encryptedSymmetricKey;

  ReceivedAcceptance({
    required this.chatId,
    required this.publicKey,
    required this.encryptedSymmetricKey,
  });
}
