import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:isar/isar.dart';

part 'stored_chat_general_data.g.dart';

@Collection()
class StoredChatGeneralData {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String chatId;

  late String chatName;

  @enumerated
  ChatSetupStatus setupStatus = ChatSetupStatus.invited;

  DateTime createdAt = DateTime.now();
}
