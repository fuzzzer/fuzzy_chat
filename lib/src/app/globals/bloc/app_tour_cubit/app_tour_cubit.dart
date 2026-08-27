import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_tour_state.dart';

class AppTourCubit extends Cubit<AppTourState> {
  AppTourCubit() : super(AppTourState(tourShown: false)) {
    ready = _getTourShownPreference().then((tourShown) {
      if (tourShown) {
        emit(state.copyWith(tourShown: true));
      }
    });
  }

  late final Future<void> ready;

  final _tourShownPreferenceKey = 'appTourShown';

  Future<void> markTourShown() async {
    if (!state.tourShown) {
      emit(state.copyWith(tourShown: true));

      await _setTourShownPreference();
    }
  }

  Future<void> _setTourShownPreference() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_tourShownPreferenceKey, true);
  }

  Future<bool> _getTourShownPreference() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_tourShownPreferenceKey) ?? false;
  }
}
