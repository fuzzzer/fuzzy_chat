part of 'invitation_reader_cubit.dart';

class InvitationReaderState {
  final StateStatus status;
  final ToBeSentInvitation? invitation;
  final DefaultFailure? failure;

  const InvitationReaderState({
    required this.status,
    this.invitation,
    this.failure,
  });

  InvitationReaderState copyWith({
    StateStatus? status,
    ToBeSentInvitation? invitation,
    DefaultFailure? failure,
  }) {
    return InvitationReaderState(
      status: status ?? this.status,
      invitation: invitation ?? this.invitation,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() => 'InvitationReaderState(status: $status, invitation: $invitation, failure: $failure)';
}
