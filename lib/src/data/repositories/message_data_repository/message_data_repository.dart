import 'package:fuzzy_chat/lib.dart';

export 'events/events.dart';

class MessageDataRepository {
  final MessageDataLocalDataSource localDataSource;

  Stream<NewMessageAdded> get newMessageUpdates => fuzzyHub.on<NewMessageAdded>();

  MessageDataRepository({required this.localDataSource});

  Future<int> addMessage(
    MessageData message, {
    bool notifyListeners = false,
  }) async {
    final storedMessage = StoredMessageData()
      ..chatId = message.chatId
      ..isSent = message.isSent
      ..messageType = message.type.name
      ..encryptedMessage = message.encryptedMessage;

    final id = await localDataSource.addMessage(storedMessage);

    if (notifyListeners) {
      fuzzyHub.sendSignal(
        NewMessageAdded(
          message: message.copyWith(
            id: storedMessage.id,
            sentAt: storedMessage.sentAt,
          ),
        ),
      );
    }

    return id;
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
