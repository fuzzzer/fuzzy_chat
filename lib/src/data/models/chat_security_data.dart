import 'package:fuzzy_chat/src/storage/storage.dart';

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

  ChatSecurityData copyWith({
    String? chatId,
    DateTime? createdAt,
    String? invitationFilePath,
    String? acceptanceFilePath,
    String? encryptedSymmetricKey,
  }) {
    return ChatSecurityData(
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      invitationFilePath: invitationFilePath ?? this.invitationFilePath,
      acceptanceFilePath: acceptanceFilePath ?? this.acceptanceFilePath,
      encryptedSymmetricKey: encryptedSymmetricKey ?? this.encryptedSymmetricKey,
    );
  }

  @override
  String toString() {
    return 'ChatSecurityData(chatId: $chatId, createdAt: $createdAt, invitationFilePath: $invitationFilePath, acceptanceFilePath: $acceptanceFilePath, encryptedSymmetricKey: $encryptedSymmetricKey)';
  }
}
