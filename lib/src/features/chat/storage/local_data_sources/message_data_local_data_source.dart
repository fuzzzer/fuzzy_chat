import 'package:isar/isar.dart';
import '../storage_models/storage_models.dart';

class StoredMessageDataLocalDataSource {
  final Isar isar;

  StoredMessageDataLocalDataSource(this.isar);

  Future<void> addMessage(StoredMessageData messageData) async {
    await isar.writeTxn(() async {
      await isar.storedMessageDatas.put(messageData);
    });
  }

  Future<List<StoredMessageData>> getMessagesForChat(String chatId) async {
    return await isar.storedMessageDatas.filter().chatIdEqualTo(chatId).sortBySentAt().findAll();
  }

  Future<void> updateMessage(StoredMessageData messageData) async {
    await isar.writeTxn(() async {
      await isar.storedMessageDatas.put(messageData);
    });
  }

  Future<void> deleteMessage(int messageId) async {
    await isar.writeTxn(() async {
      await isar.storedMessageDatas.delete(messageId);
    });
  }

  Future<void> deleteAllMessagesForChat(String chatId) async {
    final messages = await getMessagesForChat(chatId);
    await isar.writeTxn(() async {
      for (final message in messages) {
        await isar.storedMessageDatas.delete(message.id);
      }
    });
  }
}
