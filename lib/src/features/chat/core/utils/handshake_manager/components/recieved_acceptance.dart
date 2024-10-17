import 'package:pointycastle/asymmetric/api.dart';

class ReceivedAcceptance {
  final String chatId;
  final RSAPublicKey publicKey;
  final String encryptedSymmetricKey;

  ReceivedAcceptance({
    required this.chatId,
    required this.publicKey,
    required this.encryptedSymmetricKey,
  });
}
