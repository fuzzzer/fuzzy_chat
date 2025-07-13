import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzy_chat/src/fuzzy_auth/bloc/fuzzy_auth_store/components/auth_state_status.dart';

part 'fuzzy_auth_state.dart';

class FuzzyAuthStore extends Cubit<FuzzyAuthState> {
  FuzzyAuthStore()
      : super(
          const FuzzyAuthState.initial(),
        );

  Future<void> authenticate(AuthData authData) async {
    emit(
      FuzzyAuthState.authenticated(
        authData: authData,
      ),
    );
  }
}
