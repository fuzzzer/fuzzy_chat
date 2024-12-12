import 'package:fuzzy_chat/lib.dart';

class ChatDependencyInjection {
  static Future<void> inject() async {
    sl.safeRegisterSingleton<ChatGeneralDataListRepository>(
      ChatGeneralDataListRepository(localDataSource: ChatGeneralDataLocalDataSource(isar: sl.get())),
    );

    sl.safeRegisterSingleton<MessageDataRepository>(
      MessageDataRepository(localDataSource: MessageDataLocalDataSource(isar: sl.get())),
    );

    sl.safeRegisterSingleton<HandshakeManager>(HandshakeManager());
    sl.safeRegisterSingleton<KeyStorageRepository>(KeyStorageRepository());
  }
}
