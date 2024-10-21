import 'package:pointycastle/asymmetric/api.dart';

class ReceivedInvitation {
  final String chatId;
  final RSAPublicKey publicKey;

  ReceivedInvitation({
    required this.chatId,
    required this.publicKey,
  });
}
