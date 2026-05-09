import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum BiometricScope { chat, vault }

extension on BiometricScope {
  String get _flagKey => 'biometric_enabled_$name';
  String get _storageName => 'fuzzy_biometric_password_$name';

  String get _accessTitle {
    switch (this) {
      case BiometricScope.chat:
        return 'Authenticate to unlock chats';
      case BiometricScope.vault:
        return 'Authenticate to unlock vault';
    }
  }

  String get _androidTitle {
    switch (this) {
      case BiometricScope.chat:
        return 'Unlock Fuzzy Chat';
      case BiometricScope.vault:
        return 'Unlock Fuzzy Vault';
    }
  }
}

class BiometricAuthRepository {
  BiometricAuthRepository();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> canUseBiometrics() async {
    final response = await BiometricStorage().canAuthenticate();
    return response == CanAuthenticateResponse.success;
  }

  Future<bool> isEnabled(BiometricScope scope) async {
    final value = await _secureStorage.read(key: scope._flagKey);
    return value == 'true';
  }

  Future<void> enable(BiometricScope scope, String password) async {
    final storage = await _openStorage(scope);
    await storage.write(password);
    await _secureStorage.write(key: scope._flagKey, value: 'true');
  }

  Future<String?> retrievePassword(BiometricScope scope) async {
    final storage = await _openStorage(scope);
    return storage.read();
  }

  Future<void> disable(BiometricScope scope) async {
    await _secureStorage.delete(key: scope._flagKey);
    try {
      final storage = await _openStorage(scope);
      await storage.delete();
    } catch (_) {
      // Storage may already be cleared or biometrics unavailable; ignore.
    }
  }

  Future<BiometricStorageFile> _openStorage(BiometricScope scope) {
    return BiometricStorage().getStorage(
      scope._storageName,
      options: StorageFileInitOptions(
        authenticationValidityDurationSeconds: 30,
      ),
      promptInfo: PromptInfo(
        iosPromptInfo: IosPromptInfo(
          saveTitle: 'Authenticate to save password',
          accessTitle: scope._accessTitle,
        ),
        androidPromptInfo: AndroidPromptInfo(
          title: scope._androidTitle,
          subtitle: scope._accessTitle,
        ),
      ),
    );
  }
}
