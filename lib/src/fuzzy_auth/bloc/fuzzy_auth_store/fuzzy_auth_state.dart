part of 'fuzzy_auth_cubit.dart';

class FuzzyAuthState {
  final AuthStateStatus status;
  final AuthData authData;

  const FuzzyAuthState.initial()
      : status = AuthStateStatus.initial,
        authData = const AuthData(password: '');

  const FuzzyAuthState.authenticated({
    required this.authData,
  }) : status = AuthStateStatus.authenticated;
}
