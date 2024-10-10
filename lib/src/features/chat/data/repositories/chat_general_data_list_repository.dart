import '../../chat.dart';
import '../../storage/storage.dart';

class ChatGeneralDataListRepository {
  final ChatGeneralDataLocalDataSource localDataSource;

  ChatGeneralDataListRepository({required this.localDataSource});

  Future<List<ChatGeneralData>> getAllChats() async {
    return (await localDataSource.getAllChats())
        .map(
          ChatGeneralData.fromStored,
        )
        .toList();
  }

  Future<void> addChat(ChatGeneralData chat) async {
    await localDataSource.addChat(
      chat.toStored(),
    );
  }

  Future<ChatGeneralData?> getChatById(String chatId) async {
    final storedChat = await localDataSource.getChatById(chatId);
    if (storedChat != null) {
      return ChatGeneralData.fromStored(storedChat);
    }
    return null;
  }

  Future<void> updateChat(ChatGeneralData chat) async {
    await localDataSource.updateChat(chat.toStored());
  }

  Future<void> deleteChat(String chatId) async {
    await localDataSource.deleteChat(chatId);
  }
}
