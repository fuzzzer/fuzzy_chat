part of 'invitation_acceptance_cubit.dart';

class InvitationAcceptanceState {
  final StateStatus status;
  final String? chatName;
  final String? chatId;
  final ToBeSentAcceptance? generatedAcceptance;
  final DefaultFailure? failure;

  const InvitationAcceptanceState({
    required this.status,
    this.chatName,
    this.chatId,
    this.generatedAcceptance,
    this.failure,
  });

  InvitationAcceptanceState copyWith({
    StateStatus? status,
    String? chatName,
    String? chatId,
    ToBeSentAcceptance? generatedAcceptance,
    DefaultFailure? failure,
  }) {
    return InvitationAcceptanceState(
      status: status ?? this.status,
      chatName: chatName ?? this.chatName,
      chatId: chatId ?? this.chatId,
      generatedAcceptance: generatedAcceptance ?? this.generatedAcceptance,
      failure: failure ?? this.failure,
    );
  }
}
