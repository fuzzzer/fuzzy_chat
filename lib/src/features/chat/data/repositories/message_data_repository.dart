import 'package:fuzzy_chat/src/features/chat/chat.dart';

class MessageDataRepository {
  final MessageDataLocalDataSource localDataSource;

  MessageDataRepository({required this.localDataSource});

  Future<int> addMessage(MessageData message) async {
    return await localDataSource.addMessage(message.toStored());
  }

  Future<List<MessageData>> getMessagesForChat(String chatId) async {
    final storedMessages = await localDataSource.getMessagesForChat(chatId);
    return storedMessages.map(MessageData.fromStored).toList();
  }

  Future<void> deleteMessage(int messageId) async {
    await localDataSource.deleteMessage(messageId);
  }

  Future<void> deleteAllMessagesForChat(String chatId) async {
    await localDataSource.deleteAllMessagesForChat(chatId);
  }
}
