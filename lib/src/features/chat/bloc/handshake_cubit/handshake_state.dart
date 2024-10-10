part of 'handshake_cubit.dart';

class HandshakeState {
  final StateStatus status;
  final String? chatId;
  final DefaultFailure? failure;

  const HandshakeState({
    required this.status,
    this.chatId,
    this.failure,
  });

  HandshakeState copyWith({
    StateStatus? status,
    String? chatId,
    DefaultFailure? failure,
  }) {
    return HandshakeState(
      status: status ?? this.status,
      chatId: chatId ?? this.chatId,
      failure: failure ?? this.failure,
    );
  }
}
