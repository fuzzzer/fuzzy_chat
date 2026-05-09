import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'fuzzy_auth_state.dart';

class FuzzyAuthStore extends Cubit<FuzzyAuthState> {
  FuzzyAuthStore({
    required this.chatAuthRepository,
    required this.biometricAuthRepository,
  }) : super(
          const FuzzyAuthState.initial(),
        );

  final ChatAuthRepository chatAuthRepository;
  final BiometricAuthRepository biometricAuthRepository;

  Future<void> checkAuthStatus() async {
    final enabled = await chatAuthRepository.isChatAuthEnabled();
    final biometricEnabled = enabled && await biometricAuthRepository.isEnabled(BiometricScope.chat);
    if (enabled) {
      emit(state.copyWith(status: AuthStateStatus.locked, biometricEnabled: biometricEnabled));
    } else {
      emit(state.copyWith(status: AuthStateStatus.noAuthRequired, biometricEnabled: false));
    }
  }

  Future<void> unlockWithBiometrics() async {
    emit(state.copyWith(status: AuthStateStatus.unlocking));
    try {
      final password = await biometricAuthRepository.retrievePassword(BiometricScope.chat);
      if (password == null) {
        logger.w('Biometric unlock returned null password (cancelled or empty storage)');
        emit(state.copyWith(status: AuthStateStatus.locked));
        return;
      }
      await unlock(password);
    } catch (e, stack) {
      logger.e('Biometric unlock failed', error: e, stackTrace: stack);
      emit(state.copyWith(status: AuthStateStatus.locked));
    }
  }

  Future<void> unlock(String password) async {
    emit(state.copyWith(status: AuthStateStatus.unlocking));

    final isValid = await chatAuthRepository.verifyPassword(password);

    if (isValid) {
      emit(
        state.copyWith(
          status: AuthStateStatus.authenticated,
          authData: AuthData(password: password),
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStateStatus.locked,
          verificationFailed: true,
        ),
      );
    }
  }

  Future<void> authenticate(AuthData authData) async {
    emit(
      state.copyWith(
        status: AuthStateStatus.authenticated,
        authData: authData,
      ),
    );
  }

  void lock() {
    emit(
      state.copyWith(
        status: AuthStateStatus.locked,
        authData: const AuthData(password: ''),
      ),
    );
  }

  Future<void> onPasswordSetup(String password) async {
    emit(
      state.copyWith(
        status: AuthStateStatus.authenticated,
        authData: AuthData(password: password),
      ),
    );
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required List<String> chatIds,
    required KeyStorageRepository keyStorageRepository,
  }) async {
    final success = await chatAuthRepository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      chatIds: chatIds,
      keyStorageRepository: keyStorageRepository,
    );

    if (success) {
      await biometricAuthRepository.disable(BiometricScope.chat);
      emit(
        state.copyWith(
          authData: AuthData(password: newPassword),
          biometricEnabled: false,
        ),
      );
    }

    return success;
  }

  Future<void> setBiometricEnabled({required bool enabled}) async {
    emit(state.copyWith(biometricEnabled: enabled));
  }
}
