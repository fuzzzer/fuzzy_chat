part of 'chat_general_data_list_cubit.dart';

class ChatGeneralDataListState {
  final StateStatus status;
  final List<ChatGeneralData>? chats;
  final DefaultFailure? failure;

  final StateStatus actionStatus;
  final ActionType actionType;
  final DefaultFailure? actionFailure;

  const ChatGeneralDataListState({
    required this.status,
    this.chats,
    this.failure,
    this.actionStatus = StateStatus.initial,
    this.actionType = ActionType.none,
    this.actionFailure,
  });

  ChatGeneralDataListState copyWith({
    StateStatus? status,
    List<ChatGeneralData>? chats,
    DefaultFailure? failure,
    StateStatus? actionStatus,
    ActionType? actionType,
    DefaultFailure? actionFailure,
  }) {
    return ChatGeneralDataListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      failure: failure ?? this.failure,
      actionStatus: actionStatus ?? this.actionStatus,
      actionType: actionType ?? this.actionType,
      actionFailure: actionFailure ?? this.actionFailure,
    );
  }
}
