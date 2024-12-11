import 'package:fuzzy_chat/src/features/chat/chat.dart';

class MessageDataRepository {
  final MessageDataLocalDataSource localDataSource;

  MessageDataRepository({required this.localDataSource});

  Future<int> addMessage(MessageData message) async {
    final storedMessage = StoredMessageData()
      ..chatId = message.chatId
      ..isSent = message.isSent
      ..encryptedMessage = message.encryptedMessage;

    return await localDataSource.addMessage(storedMessage);
  }

  Future<List<MessageData>> getMessagesForChat(String chatId) async {
    final storedMessages = await localDataSource.getMessagesForChat(chatId);
    return storedMessages.map(MessageData.fromStored).toList();
  }

  Future<List<MessageData>> getMessagesForChatPaginated(
    String chatId, {
    required int pageSize,
    required int pageIndex,
  }) async {
    final storedMessages = await localDataSource.getMessagesForChatPaginated(
      chatId,
      pageSize: pageSize,
      pageIndex: pageIndex,
    );

    return storedMessages.map(MessageData.fromStored).toList();
  }

  Future<void> deleteMessage(int messageId) async {
    await localDataSource.deleteMessage(messageId);
  }

  Future<void> deleteAllMessagesForChat(String chatId) async {
    await localDataSource.deleteAllMessagesForChat(chatId);
  }
}
