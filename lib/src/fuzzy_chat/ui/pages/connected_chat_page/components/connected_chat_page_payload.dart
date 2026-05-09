import 'package:fuzzy_chat/lib.dart';

class ConnectedChatPagePayload {
  final ChatGeneralData chatGeneralData;
  final String? prefillEncryptedMessage;

  ConnectedChatPagePayload({
    required this.chatGeneralData,
    this.prefillEncryptedMessage,
  });
}
