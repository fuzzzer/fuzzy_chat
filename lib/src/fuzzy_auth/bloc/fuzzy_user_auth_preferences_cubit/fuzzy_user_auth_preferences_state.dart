part of 'fuzzy_user_auth_preferences_cubit.dart';

class FuzzyUserAuthPreferencesState {
  final StateStatus activationStatus;
  final DefaultFailure? activationFailure;

  const FuzzyUserAuthPreferencesState({
    required this.activationStatus,
    this.activationFailure,
  });

  FuzzyUserAuthPreferencesState copyWith({
    StateStatus? activationStatus,
    DefaultFailure? activationFailure,
  }) {
    return FuzzyUserAuthPreferencesState(
      activationStatus: activationStatus ?? this.activationStatus,
      activationFailure: activationFailure ?? this.activationFailure,
    );
  }

  @override
  String toString() {
    return 'FuzzyUserAuthPreferencesState(activationStatus: $activationStatus, activationFailure: $activationFailure)';
  }
}
