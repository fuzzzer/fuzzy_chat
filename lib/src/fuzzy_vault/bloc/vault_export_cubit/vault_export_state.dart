part of 'vault_export_cubit.dart';

class VaultExportState {
  const VaultExportState({
    this.status = StateStatus.initial,
    this.failureType,
  });

  final StateStatus status;
  final VaultFailureType? failureType;

  VaultExportState copyWith({
    StateStatus? status,
    VaultFailureType? failureType,
  }) {
    return VaultExportState(
      status: status ?? this.status,
      failureType: failureType ??
          (status == StateStatus.success ? null : this.failureType),
    );
  }
}
