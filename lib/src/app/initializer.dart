import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../features/chat/chat.dart';

class Initializer {
  static Future<void> preAppInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [
        StoredChatGeneralDataSchema,
        StoredChatPreferencesSchema,
        StoredChatSecurityDataSchema,
        StoredMessageDataSchema,
      ],
      directory: appDocumentsDirectory.path,
    );

    sl.safeRegisterSingleton<AppDocumentsDirectory>(
      AppDocumentsDirectory(
        directory: appDocumentsDirectory,
      ),
    );

    sl.safeRegisterSingleton<Isar>(isar);

    sl.safeRegisterSingleton<ChatGeneralDataListRepository>(
      ChatGeneralDataListRepository(localDataSource: ChatGeneralDataLocalDataSource(isar: isar)),
    );

    sl.safeRegisterSingleton<MessageDataRepository>(
      MessageDataRepository(localDataSource: MessageDataLocalDataSource(isar: isar)),
    );

    sl.safeRegisterSingleton<HandshakeManager>(HandshakeManager());
    sl.safeRegisterSingleton<KeyStorageRepository>(KeyStorageRepository());
  }
}
