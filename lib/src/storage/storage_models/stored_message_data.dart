import 'package:fuzzy_chat/lib.dart';
import 'package:isar/isar.dart';

part 'stored_message_data.g.dart';

@Collection()
class StoredMessageData {
  Id id = Isar.autoIncrement;

  @Index()
  late String chatId;

  late String encryptedMessage;
  String messageType = MessageType.text.name;

  DateTime sentAt = DateTime.now();

  bool isSent = false;
}
