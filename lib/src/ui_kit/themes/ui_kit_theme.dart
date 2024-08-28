import 'package:flutter/material.dart';

import 'themes.dart';

class UiKitTheme {
  static const UiColors lightUiColors = UiColors.light();
  static const UiColors darkUiColors = UiColors.dark();

  static const UiTextStyles uiTextStyles = UiTextStyles();

  static ColorScheme lightColorScheme() => ColorScheme.fromSeed(
        seedColor: lightUiColors.primaryColor,
        primary: lightUiColors.primaryColor,
        secondary: lightUiColors.secondaryColor,
        error: lightUiColors.errorColor,
        background: lightUiColors.backgroundPrimaryColor,
      );

  static ColorScheme darkColorScheme() => ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: darkUiColors.primaryColor,
        primary: darkUiColors.primaryColor,
        secondary: darkUiColors.secondaryColor,
        error: darkUiColors.errorColor,
        background: darkUiColors.backgroundPrimaryColor,
      );

  static ThemeData light({
    Locale locale = const Locale('en'),
  }) {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: lightColorScheme(),
      primaryColor: lightUiColors.primaryColor,
      focusColor: lightUiColors.focusColor,
      textTheme: const TextTheme()
        ..apply(
          bodyColor: lightUiColors.primaryColor,
          displayColor: lightUiColors.primaryColor,
        ),
      extensions: <ThemeExtension<dynamic>>[
        lightUiColors,
        uiTextStyles.apply(
          color: lightUiColors.primaryTextColor,
        ),
      ],
    );
  }

  static ThemeData dark({
    Locale locale = const Locale('en'),
  }) {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: darkColorScheme(),
      primaryColor: darkUiColors.primaryColor,
      focusColor: darkUiColors.focusColor,
      textTheme: const TextTheme()
        ..apply(
          bodyColor: darkUiColors.primaryColor,
          displayColor: darkUiColors.primaryColor,
        ),
      extensions: <ThemeExtension<dynamic>>[
        darkUiColors,
        uiTextStyles.apply(
          color: darkUiColors.primaryTextColor,
        ),
      ],
    );
  }
}
