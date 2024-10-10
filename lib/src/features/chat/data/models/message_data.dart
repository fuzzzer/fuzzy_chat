import 'package:fuzzy_chat/src/features/chat/storage/storage.dart';

class MessageData {
  final String chatId;
  final String fuzzyMessage;
  final DateTime sentAt;
  final bool isSent; //Same as isEncryped

  MessageData({
    required this.chatId,
    required this.fuzzyMessage,
    required this.sentAt,
    required this.isSent,
  });

  factory MessageData.fromStored(StoredMessageData stored) {
    return MessageData(
      chatId: stored.chatId,
      fuzzyMessage: stored.fuzzyMessage,
      sentAt: stored.sentAt,
      isSent: stored.isSent,
    );
  }

  StoredMessageData toStored() {
    return StoredMessageData()
      ..chatId = chatId
      ..fuzzyMessage = fuzzyMessage
      ..sentAt = sentAt
      ..isSent = isSent;
  }

  MessageData copyWith({
    String? chatId,
    String? fuzzyMessage,
    DateTime? sentAt,
    bool? isSent,
  }) {
    return MessageData(
      chatId: chatId ?? this.chatId,
      fuzzyMessage: fuzzyMessage ?? this.fuzzyMessage,
      sentAt: sentAt ?? this.sentAt,
      isSent: isSent ?? this.isSent,
    );
  }
}
