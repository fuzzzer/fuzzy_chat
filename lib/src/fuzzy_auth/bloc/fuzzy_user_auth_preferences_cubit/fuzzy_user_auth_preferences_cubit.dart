import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'fuzzy_user_auth_preferences_state.dart';

class FuzzyUserAuthPreferencesCubit extends Cubit<FuzzyUserAuthPreferencesState> {
  final UserAuthPreferencesRepository _userAuthPreferencesRepository;

  FuzzyUserAuthPreferencesCubit({
    required UserAuthPreferencesRepository userAuthPreferencesRepository,
  })  : _userAuthPreferencesRepository = userAuthPreferencesRepository,
        super(
          const FuzzyUserAuthPreferencesState(
            checkCurrentAuthPreferencesStatus: StateStatus.initial,
            activationStatus: StateStatus.initial,
          ),
        );

  Future<void> getUserAuthPreferences() async {
    emit(state.copyWith(checkCurrentAuthPreferencesStatus: StateStatus.loading));
    try {
      final item = await _userAuthPreferencesRepository.getUserAuthPreferences();
      emit(
        state.copyWith(
          checkCurrentAuthPreferencesStatus: StateStatus.success,
          currentAuthPreferences: item,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          checkCurrentAuthPreferencesStatus: StateStatus.failed,
          checkCurrentAuthPreferencesFailure: DefaultFailure(message: e.toString()),
        ),
      );
    }
  }

  Future<void> activateAuth() async {
    emit(
      state.copyWith(
        activationStatus: StateStatus.loading,
      ),
    );
    try {
      await _userAuthPreferencesRepository.updateUserAuthPreferences(
        UserAuthPreferences(
          isAuthenticationOnceEnabled: true,
        ),
      );

      emit(
        state.copyWith(
          activationStatus: StateStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          activationStatus: StateStatus.failed,
          activationFailure: DefaultFailure(
            message: e.toString(),
          ),
        ),
      );
    }
  }
}
