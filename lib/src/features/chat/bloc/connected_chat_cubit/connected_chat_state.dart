part of 'connected_chat_cubit.dart';

class ConnectedChatState {
  final StateStatus status;
  final List<MessageData> messages;
  final DefaultFailure? failure;

  final StateStatus actionStatus;
  final ChatActionType actionType;
  final DefaultFailure? actionFailure;

  const ConnectedChatState({
    required this.status,
    required this.messages,
    this.failure,
    this.actionStatus = StateStatus.initial,
    this.actionType = ChatActionType.none,
    this.actionFailure,
  });

  ConnectedChatState copyWith({
    StateStatus? status,
    List<MessageData>? messages,
    DefaultFailure? failure,
    StateStatus? actionStatus,
    ChatActionType? actionType,
    DefaultFailure? actionFailure,
  }) {
    return ConnectedChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      failure: failure ?? this.failure,
      actionStatus: actionStatus ?? this.actionStatus,
      actionType: actionType ?? this.actionType,
      actionFailure: actionFailure ?? this.actionFailure,
    );
  }

  @override
  String toString() {
    return 'ConnectedChatState(status: $status, messages: $messages, failure: $failure, actionStatus: $actionStatus, actionType: $actionType, actionFailure: $actionFailure)';
  }
}

enum ChatActionType {
  none,
  sendMessage,
  receiveMessage,
  deleteMessage,
  deleteAllMessages,
}
