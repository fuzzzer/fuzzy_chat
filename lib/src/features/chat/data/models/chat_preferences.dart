import 'package:fuzzy_chat/src/features/chat/storage/storage.dart';

class ChatPreferences {
  final String? theme;
  final bool showTimestamps;
  final DateTime lastUpdated;

  ChatPreferences({
    required this.showTimestamps,
    required this.lastUpdated,
    this.theme,
  });

  factory ChatPreferences.fromStored(StoredChatPreferences stored) {
    return ChatPreferences(
      theme: stored.theme,
      showTimestamps: stored.showTimestamps,
      lastUpdated: stored.lastUpdated,
    );
  }

  StoredChatPreferences toStored() {
    return StoredChatPreferences()
      ..theme = theme
      ..showTimestamps = showTimestamps
      ..lastUpdated = lastUpdated;
  }
}
