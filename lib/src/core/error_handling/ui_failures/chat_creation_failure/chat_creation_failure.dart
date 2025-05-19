import 'chat_creation_failure_type.dart';

export 'chat_creation_failure_type.dart';
export 'components.dart';

class ChatCreationFailure {
  ///Not to be used to show user
  final String? internalMessage;

  ///To be used to generate message for user, for ui to generate localized message
  final ChatCreationFailureType type;

  ChatCreationFailure({
    this.internalMessage,
    required this.type,
  });
}
