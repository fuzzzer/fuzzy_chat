// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fuzzy_user_auth_preferences_cubit.dart';

class FuzzyUserAuthPreferencesState {
  final StateStatus checkCurrentAuthPreferencesStatus;
  final UserAuthPreferences? currentAuthPreferences;
  final DefaultFailure? checkCurrentAuthPreferencesFailure;

  final StateStatus activationStatus;
  final DefaultFailure? activationFailure;

  bool get isAuthActivated => currentAuthPreferences?.isAuthenticationOnceEnabled == true;

  const FuzzyUserAuthPreferencesState({
    required this.checkCurrentAuthPreferencesStatus,
    this.currentAuthPreferences,
    this.checkCurrentAuthPreferencesFailure,
    required this.activationStatus,
    this.activationFailure,
  });

  FuzzyUserAuthPreferencesState copyWith({
    StateStatus? checkCurrentAuthPreferencesStatus,
    UserAuthPreferences? currentAuthPreferences,
    DefaultFailure? checkCurrentAuthPreferencesFailure,
    StateStatus? activationStatus,
    DefaultFailure? activationFailure,
  }) {
    return FuzzyUserAuthPreferencesState(
      checkCurrentAuthPreferencesStatus: checkCurrentAuthPreferencesStatus ?? this.checkCurrentAuthPreferencesStatus,
      currentAuthPreferences: currentAuthPreferences ?? this.currentAuthPreferences,
      checkCurrentAuthPreferencesFailure: checkCurrentAuthPreferencesFailure ?? this.checkCurrentAuthPreferencesFailure,
      activationStatus: activationStatus ?? this.activationStatus,
      activationFailure: activationFailure ?? this.activationFailure,
    );
  }

  @override
  String toString() {
    return 'FuzzyUserAuthState(status: $checkCurrentAuthPreferencesStatus, item: $currentAuthPreferences, failure: $checkCurrentAuthPreferencesFailure, setupStatus: $activationStatus, setupFailure: $activationFailure)';
  }
}
