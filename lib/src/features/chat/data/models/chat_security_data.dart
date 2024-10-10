import 'package:fuzzy_chat/src/features/chat/storage/storage.dart';

class ChatSecurityData {
  final String chatId;
  final DateTime createdAt;
  final String? invitationFilePath;
  final String? acceptanceFilePath;
  final String? encryptedSymmetricKey;

  ChatSecurityData({
    required this.chatId,
    required this.createdAt,
    this.invitationFilePath,
    this.acceptanceFilePath,
    this.encryptedSymmetricKey,
  });

  factory ChatSecurityData.fromStored(StoredChatSecurityData stored) {
    return ChatSecurityData(
      chatId: stored.chatId,
      invitationFilePath: stored.invitationFilePath,
      acceptanceFilePath: stored.acceptanceFilePath,
      encryptedSymmetricKey: stored.encryptedSymmetricKey,
      createdAt: stored.createdAt,
    );
  }

  StoredChatSecurityData toStored() {
    return StoredChatSecurityData()
      ..chatId = chatId
      ..invitationFilePath = invitationFilePath
      ..acceptanceFilePath = acceptanceFilePath
      ..encryptedSymmetricKey = encryptedSymmetricKey
      ..createdAt = createdAt;
  }
}
