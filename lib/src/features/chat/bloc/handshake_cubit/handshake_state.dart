part of 'handshake_cubit.dart';

class HandshakeState {
  final StateStatus status;
  final ChatGeneralData? chatData;
  final DefaultFailure? failure;

  const HandshakeState({
    required this.status,
    this.chatData,
    this.failure,
  });

  HandshakeState copyWith({
    StateStatus? status,
    ChatGeneralData? chatData,
    DefaultFailure? failure,
  }) {
    return HandshakeState(
      status: status ?? this.status,
      chatData: chatData ?? this.chatData,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() => 'HandshakeState(status: $status, chatData: $chatData, failure: $failure)';
}
