part of 'chat_creation_cubit.dart';

class ChatCreationState {
  final StateStatus status;
  final String? chatName;
  final String? chatId;
  final DefaultFailure? failure;

  const ChatCreationState({
    required this.status,
    this.chatName,
    this.chatId,
    this.failure,
  });

  ChatCreationState copyWith({
    StateStatus? status,
    String? chatName,
    String? chatId,
    DefaultFailure? failure,
  }) {
    return ChatCreationState(
      status: status ?? this.status,
      chatName: chatName ?? this.chatName,
      chatId: chatId ?? this.chatId,
      failure: failure ?? this.failure,
    );
  }
}
