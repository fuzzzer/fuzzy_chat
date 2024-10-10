import 'package:isar/isar.dart';

part 'stored_message_data.g.dart';

@Collection()
class StoredMessageData {
  Id id = Isar.autoIncrement;

  @Index()
  late String chatId;

  late String fuzzyMessage;

  DateTime sentAt = DateTime.now();

  bool isSent = false;
}
