part of 'theme_cubit.dart';

class ThemeState {
  final ChosenBrightness chosenBrightness;

  ThemeState({
    required this.chosenBrightness,
  });

  ThemeState copyWith({
    ChosenBrightness? chosenBrightness,
  }) {
    return ThemeState(
      chosenBrightness: chosenBrightness ?? this.chosenBrightness,
    );
  }
}

Brightness getBrightnessFromChosenBrightness(ChosenBrightness brightness) {
  return brightness.isSystem
      ? WidgetsBinding.instance.platformDispatcher.platformBrightness.isLight
          ? Brightness.light
          : Brightness.dark
      : brightness.isLight
          ? Brightness.light
          : Brightness.dark;
}
