// invitation_acceptance_cubit.dart

part of 'invitation_acceptance_cubit.dart';

class InvitationAcceptanceState {
  final StateStatus status;
  final String? chatId;
  final DefaultFailure? failure;

  const InvitationAcceptanceState({
    required this.status,
    this.chatId,
    this.failure,
  });

  InvitationAcceptanceState copyWith({
    StateStatus? status,
    String? chatId,
    DefaultFailure? failure,
  }) {
    return InvitationAcceptanceState(
      status: status ?? this.status,
      chatId: chatId ?? this.chatId,
      failure: failure ?? this.failure,
    );
  }
}
