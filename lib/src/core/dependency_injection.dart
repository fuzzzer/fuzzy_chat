import 'dart:io';

import 'package:fuzzy_chat/lib.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DependencyInjection {
  static Future<void> inject() async {
    late final Directory documentsDirectory;
    late final Directory supportDirectory;

    await Future.wait<void>([
      (() async => documentsDirectory = await getApplicationDocumentsDirectory())(),
      (() async => supportDirectory = await getApplicationSupportDirectory())(),
    ]);

    sl.safeRegisterSingleton<AppDocumentsDirectory>(
      AppDocumentsDirectory(
        directory: documentsDirectory,
      ),
    );

    sl.safeRegisterSingleton<AppSupportDirectory>(
      AppSupportDirectory(
        directory: supportDirectory,
      ),
    );

    final isar = await Isar.open(
      [
        StoredChatGeneralDataSchema,
        StoredChatPreferencesSchema,
        StoredChatSecurityDataSchema,
        StoredMessageDataSchema,
      ],
      directory: supportDirectory.path,
    );

    sl.safeRegisterSingleton<Isar>(isar);

    await ChatDependencyInjection.inject();
  }
}
