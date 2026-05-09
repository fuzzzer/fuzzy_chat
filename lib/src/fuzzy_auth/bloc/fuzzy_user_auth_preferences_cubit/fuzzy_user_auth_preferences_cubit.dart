import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'fuzzy_user_auth_preferences_state.dart';

class FuzzyUserAuthPreferencesCubit
    extends Cubit<FuzzyUserAuthPreferencesState> {
  final ChatAuthRepository _chatAuthRepository;
  final ChatGeneralDataListRepository _chatGeneralDataListRepository;
  final KeyStorageRepository _keyStorageRepository;
  final FuzzyAuthStore _fuzzyAuthStore;
  final BiometricAuthRepository _biometricAuthRepository;

  FuzzyUserAuthPreferencesCubit({
    required ChatAuthRepository chatAuthRepository,
    required ChatGeneralDataListRepository chatGeneralDataListRepository,
    required KeyStorageRepository keyStorageRepository,
    required FuzzyAuthStore fuzzyAuthStore,
    required BiometricAuthRepository biometricAuthRepository,
  })  : _chatAuthRepository = chatAuthRepository,
        _chatGeneralDataListRepository = chatGeneralDataListRepository,
        _keyStorageRepository = keyStorageRepository,
        _fuzzyAuthStore = fuzzyAuthStore,
        _biometricAuthRepository = biometricAuthRepository,
        super(
          const FuzzyUserAuthPreferencesState(
            activationStatus: StateStatus.initial,
          ),
        );

  Future<void> enableAuth(String password) async {
    emit(state.copyWith(activationStatus: StateStatus.loading));
    try {
      final chatIds = await _allChatIds();
      await _keyStorageRepository.reencryptAllKeys(
        chatIds: chatIds,
        oldPassword: '',
        newPassword: password,
      );
      await _chatAuthRepository.setupPassword(password);
      await _fuzzyAuthStore.onPasswordSetup(password);
      emit(state.copyWith(
        activationStatus: StateStatus.success,
        lastAction: AuthPreferencesAction.enable,
      ),);
    } catch (e) {
      emit(
        state.copyWith(
          activationStatus: StateStatus.failed,
          activationFailure: DefaultFailure(message: e.toString()),
        ),
      );
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(activationStatus: StateStatus.loading));
    try {
      final chatIds = await _allChatIds();
      final success = await _fuzzyAuthStore.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        chatIds: chatIds,
        keyStorageRepository: _keyStorageRepository,
      );

      if (success) {
        emit(state.copyWith(
          activationStatus: StateStatus.success,
          lastAction: AuthPreferencesAction.changePassword,
        ),);
      } else {
        emit(
          state.copyWith(
            activationStatus: StateStatus.failed,
            activationFailure: DefaultFailure(
              message: currentContextLocalization.chatAuthIncorrectPassword,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          activationStatus: StateStatus.failed,
          activationFailure: DefaultFailure(message: e.toString()),
        ),
      );
    }
  }

  Future<void> disableAuth(String currentPassword) async {
    emit(state.copyWith(activationStatus: StateStatus.loading));
    try {
      final isValid = await _chatAuthRepository.verifyPassword(currentPassword);
      if (!isValid) {
        emit(
          state.copyWith(
            activationStatus: StateStatus.failed,
            activationFailure: DefaultFailure(
              message: currentContextLocalization.chatAuthIncorrectPassword,
            ),
          ),
        );
        return;
      }

      final chatIds = await _allChatIds();
      await _keyStorageRepository.reencryptAllKeys(
        chatIds: chatIds,
        oldPassword: currentPassword,
        newPassword: '',
      );
      await _chatAuthRepository.disableAuth();
      await _biometricAuthRepository.disable(BiometricScope.chat);
      await _fuzzyAuthStore.checkAuthStatus();
      emit(state.copyWith(
        activationStatus: StateStatus.success,
        lastAction: AuthPreferencesAction.disable,
      ),);
    } catch (e) {
      emit(
        state.copyWith(
          activationStatus: StateStatus.failed,
          activationFailure: DefaultFailure(message: e.toString()),
        ),
      );
    }
  }

  Future<void> enableBiometric(String currentPassword) async {
    emit(state.copyWith(activationStatus: StateStatus.loading));
    try {
      final isValid = await _chatAuthRepository.verifyPassword(currentPassword);
      if (!isValid) {
        emit(
          state.copyWith(
            activationStatus: StateStatus.failed,
            activationFailure: DefaultFailure(
              message: currentContextLocalization.chatAuthIncorrectPassword,
            ),
          ),
        );
        return;
      }

      await _biometricAuthRepository.enable(
          BiometricScope.chat, currentPassword,);
      await _fuzzyAuthStore.setBiometricEnabled(enabled: true);
      emit(state.copyWith(
        activationStatus: StateStatus.success,
        lastAction: AuthPreferencesAction.enableBiometric,
      ),);
    } catch (e) {
      emit(
        state.copyWith(
          activationStatus: StateStatus.failed,
          activationFailure: DefaultFailure(message: e.toString()),
        ),
      );
    }
  }

  Future<void> disableBiometric() async {
    emit(state.copyWith(activationStatus: StateStatus.loading));
    try {
      await _biometricAuthRepository.disable(BiometricScope.chat);
      await _fuzzyAuthStore.setBiometricEnabled(enabled: false);
      emit(state.copyWith(
        activationStatus: StateStatus.success,
        lastAction: AuthPreferencesAction.disableBiometric,
      ),);
    } catch (e) {
      emit(
        state.copyWith(
          activationStatus: StateStatus.failed,
          activationFailure: DefaultFailure(message: e.toString()),
        ),
      );
    }
  }

  Future<List<String>> _allChatIds() async {
    final chats = await _chatGeneralDataListRepository.getAllChats();
    return chats.map((chat) => chat.chatId).toList();
  }
}
