import 'package:fuzzy_chat/lib.dart';

enum ChatCreationFailureType {
  existingName,
  unknown;

  String toUiMessage(
    FuzzyChatLocalizations localizations, {
    String? customUnknownMessage,
  }) {
    return switch (this) {
      ChatCreationFailureType.existingName => localizations.chatWithIndicatedNameAlreadyExists,
      ChatCreationFailureType.unknown => customUnknownMessage ?? localizations.failedToCreateChat,
    };
  }
}
