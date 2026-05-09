part of 'vault_auth_cubit.dart';

enum VaultAuthEnum { initial, noVault, locked, unlocking, unlocked }

class VaultAuthState {
  const VaultAuthState({
    this.status = StateStatus.initial,
    this.authState = VaultAuthEnum.initial,
    this.masterKey,
    this.failureType,
    this.biometricEnabled = false,
  });

  final StateStatus status;
  final VaultAuthEnum authState;
  final Uint8List? masterKey;
  final VaultFailureType? failureType;
  final bool biometricEnabled;

  VaultAuthState copyWith({
    StateStatus? status,
    VaultAuthEnum? authState,
    Uint8List? masterKey,
    VaultFailureType? failureType,
    bool? biometricEnabled,
  }) {
    return VaultAuthState(
      status: status ?? this.status,
      authState: authState ?? this.authState,
      masterKey: masterKey ?? this.masterKey,
      failureType: failureType ??
          (status == StateStatus.success ? null : this.failureType),
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
