import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzy_chat/src/features/chat/core/chat_dependency_injection.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DependencyInjection {
  static Future<void> inject() async {
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

    await ChatDependencyInjection.inject();
  }
}
