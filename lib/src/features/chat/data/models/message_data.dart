import 'package:fuzzy_chat/src/features/chat/storage/storage.dart';

class MessageData {
  final int id;
  final String chatId;
  final String encryptedMessage;
  final String decryptedMessage;
  final DateTime sentAt;
  final bool isSent;

  MessageData({
    required this.id,
    required this.chatId,
    required this.encryptedMessage,
    required this.decryptedMessage,
    required this.sentAt,
    required this.isSent,
  });

  factory MessageData.fromStored(StoredMessageData stored) {
    return MessageData(
      id: stored.id,
      chatId: stored.chatId,
      encryptedMessage: stored.encryptedMessage,
      decryptedMessage: '',
      sentAt: stored.sentAt,
      isSent: stored.isSent,
    );
  }

  StoredMessageData toStored() {
    return StoredMessageData()
      ..id = id
      ..chatId = chatId
      ..encryptedMessage = encryptedMessage
      ..sentAt = sentAt
      ..isSent = isSent;
  }

  MessageData copyWith({
    int? id,
    String? chatId,
    String? encryptedMessage,
    String? decryptedMessage,
    DateTime? sentAt,
    bool? isSent,
  }) {
    return MessageData(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      encryptedMessage: encryptedMessage ?? this.encryptedMessage,
      decryptedMessage: decryptedMessage ?? this.decryptedMessage,
      sentAt: sentAt ?? this.sentAt,
      isSent: isSent ?? this.isSent,
    );
  }
}
