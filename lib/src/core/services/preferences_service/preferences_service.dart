// ignore_for_file: avoid_positional_boolean_parameters

import 'package:shared_preferences/shared_preferences.dart';

enum CopySecurityLevel {
  strict, // Prompts confirmation before copy
  moderate, // Copies directly
}

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const _hasCompletedTutorialKey = 'has_completed_tutorial';
  static const _copySecurityLevelKey = 'copy_security_level';

  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;
  Future<void> setHasSeenOnboarding(bool value) => _prefs.setBool(_hasSeenOnboardingKey, value);

  bool get hasCompletedTutorial => _prefs.getBool(_hasCompletedTutorialKey) ?? false;
  Future<void> setHasCompletedTutorial(bool value) => _prefs.setBool(_hasCompletedTutorialKey, value);

  CopySecurityLevel get copySecurityLevel {
    final value = _prefs.getString(_copySecurityLevelKey);
    if (value == CopySecurityLevel.moderate.name) {
      return CopySecurityLevel.moderate;
    }
    return CopySecurityLevel.strict; // default
  }

  Future<void> setCopySecurityLevel(CopySecurityLevel level) => _prefs.setString(_copySecurityLevelKey, level.name);
}
