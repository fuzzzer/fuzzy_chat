import '../../storage/storage.dart';
import 'enums/enums.dart';

class ChatGeneralData {
  final String chatId;
  final String chatName;
  final ChatSetupStatus setupStatus;

  ChatGeneralData({
    required this.chatId,
    required this.chatName,
    required this.setupStatus,
  });

  factory ChatGeneralData.fromStored(StoredChatGeneralData stored) {
    return ChatGeneralData(
      chatId: stored.chatId,
      chatName: stored.chatName,
      setupStatus: stored.setupStatus,
    );
  }

  StoredChatGeneralData toStored() {
    return StoredChatGeneralData()
      ..chatId = chatId
      ..chatName = chatName
      ..setupStatus = setupStatus
      ..createdAt = DateTime.now();
  }

  ChatGeneralData copyWith({
    String? chatId,
    String? chatName,
    ChatSetupStatus? setupStatus,
  }) {
    return ChatGeneralData(
      chatId: chatId ?? this.chatId,
      chatName: chatName ?? this.chatName,
      setupStatus: setupStatus ?? this.setupStatus,
    );
  }
}
