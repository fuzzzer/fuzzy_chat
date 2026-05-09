part of 'fuzzy_auth_cubit.dart';

class FuzzyAuthState {
  final AuthStateStatus status;
  final AuthData authData;
  final bool verificationFailed;
  final bool biometricEnabled;

  const FuzzyAuthState._({
    required this.status,
    required this.authData,
    this.verificationFailed = false,
    this.biometricEnabled = false,
  });

  const FuzzyAuthState.initial()
      : status = AuthStateStatus.initial,
        authData = const AuthData(password: ''),
        verificationFailed = false,
        biometricEnabled = false;

  FuzzyAuthState copyWith({
    AuthStateStatus? status,
    AuthData? authData,
    bool? verificationFailed,
    bool? biometricEnabled,
  }) {
    return FuzzyAuthState._(
      status: status ?? this.status,
      authData: authData ?? this.authData,
      verificationFailed: verificationFailed ?? false,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
