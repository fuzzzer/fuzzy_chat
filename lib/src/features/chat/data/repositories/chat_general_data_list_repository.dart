import '../../chat.dart';

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
    final storedChatGeneralData = StoredChatGeneralData()
      ..chatId = chat.chatId
      ..chatName = chat.chatName
      ..setupStatus = chat.setupStatus
      ..didAcceptInvitation = chat.didAcceptInvitation;

    await localDataSource.addChat(
      storedChatGeneralData,
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
    final storedGeneralChatData = await localDataSource.getChatById(chat.chatId);

    if (storedGeneralChatData != null) {
      storedGeneralChatData
        ..chatName = chat.chatName
        ..setupStatus = chat.setupStatus
        ..didAcceptInvitation = chat.didAcceptInvitation;

      await localDataSource.updateChat(storedGeneralChatData);
    }
  }

  Future<void> deleteChat(String chatId) async {
    await localDataSource.deleteChat(chatId);
  }
}
