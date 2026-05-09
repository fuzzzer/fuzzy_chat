part of 'vault_groups_cubit.dart';

class VaultGroupsState {
  const VaultGroupsState({
    this.status = StateStatus.initial,
    this.groups = const [],
    this.failureType,
  });

  final StateStatus status;
  final List<VaultGroupData> groups;
  final VaultFailureType? failureType;

  VaultGroupsState copyWith({
    StateStatus? status,
    List<VaultGroupData>? groups,
    VaultFailureType? failureType,
  }) {
    return VaultGroupsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      failureType: failureType ??
          (status == StateStatus.success ? null : this.failureType),
    );
  }
}
