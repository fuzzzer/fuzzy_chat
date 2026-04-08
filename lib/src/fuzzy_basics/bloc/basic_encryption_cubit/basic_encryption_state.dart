part of 'basic_encryption_cubit.dart';

class BasicEncryptionState {
  final StateStatus status;
  final String? result;
  final DefaultFailure? failure;

  const BasicEncryptionState({
    required this.status,
    this.result,
    this.failure,
  });

  BasicEncryptionState copyWith({
    StateStatus? status,
    String? result,
    DefaultFailure? failure,
  }) {
    return BasicEncryptionState(
      status: status ?? this.status,
      result: result ?? this.result,
      failure: failure,
    );
  }
}
