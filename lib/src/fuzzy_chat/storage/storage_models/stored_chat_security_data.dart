import 'package:isar/isar.dart';

part 'stored_chat_security_data.g.dart';

@Collection()
class StoredChatSecurityData {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String chatId;

  String? invitationFilePath;

  String? acceptanceFilePath;

  String? encryptedSymmetricKey;

  DateTime createdAt = DateTime.now();
}
