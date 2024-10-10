import 'package:isar/isar.dart';
import '../storage_models/storage_models.dart';

class StoredChatSecurityDataLocalDataSource {
  final Isar isar;

  StoredChatSecurityDataLocalDataSource(this.isar);

  Future<void> addSecurityData(StoredChatSecurityData securityData) async {
    await isar.writeTxn(() async {
      await isar.storedChatSecurityDatas.put(securityData);
    });
  }

  Future<StoredChatSecurityData?> getSecurityDataForChat(String chatId) async {
    return await isar.storedChatSecurityDatas.filter().chatIdEqualTo(chatId).findFirst();
  }

  Future<void> updateSecurityData(StoredChatSecurityData securityData) async {
    await isar.writeTxn(() async {
      await isar.storedChatSecurityDatas.put(securityData);
    });
  }

  Future<void> deleteSecurityData(String chatId) async {
    final securityData = await getSecurityDataForChat(chatId);
    if (securityData != null) {
      await isar.writeTxn(() async {
        await isar.storedChatSecurityDatas.delete(securityData.id);
      });
    }
  }
}
