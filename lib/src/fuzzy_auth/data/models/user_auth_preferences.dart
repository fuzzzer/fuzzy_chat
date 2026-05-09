import '../../storage/storage_models/stored_user_auth_preferences.dart';

class UserAuthPreferences {
  final bool isAuthenticationOnceEnabled;

  UserAuthPreferences({
    required this.isAuthenticationOnceEnabled,
  });

  factory UserAuthPreferences.fromStored(StoredUserAuthPreferences stored) {
    return UserAuthPreferences(
      isAuthenticationOnceEnabled: stored.isAuthenticationOnceEnabled,
    );
  }

  UserAuthPreferences copyWith({
    bool? isAuthenticationOnceEnabled,
  }) {
    return UserAuthPreferences(
      isAuthenticationOnceEnabled:
          isAuthenticationOnceEnabled ?? this.isAuthenticationOnceEnabled,
    );
  }
}
