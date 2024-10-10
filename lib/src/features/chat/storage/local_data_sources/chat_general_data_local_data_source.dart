import 'package:isar/isar.dart';
import '../storage_models/storage_models.dart';

class ChatGeneralDataLocalDataSource {
  final Isar isar;

  ChatGeneralDataLocalDataSource(this.isar);

  Future<void> addChat(StoredChatGeneralData chatGeneralData) async {
    await isar.writeTxn(() async {
      await isar.storedChatGeneralDatas.put(chatGeneralData);
    });
  }

  Future<StoredChatGeneralData?> getChatById(String chatId) async {
    return await isar.storedChatGeneralDatas.filter().chatIdEqualTo(chatId).findFirst();
  }

  Future<List<StoredChatGeneralData>> getAllChats() async {
    return await isar.storedChatGeneralDatas.where().findAll();
  }

  Future<void> updateChat(StoredChatGeneralData chatGeneralData) async {
    await isar.writeTxn(() async {
      await isar.storedChatGeneralDatas.put(chatGeneralData);
    });
  }

  Future<void> deleteChat(String chatId) async {
    final chatGeneralData = await getChatById(chatId);
    if (chatGeneralData != null) {
      await isar.writeTxn(() async {
        await isar.storedChatGeneralDatas.delete(chatGeneralData.id);
      });
    }
  }
}
