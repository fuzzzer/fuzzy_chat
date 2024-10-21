import 'package:flutter/material.dart';

import 'themes.dart';

class UiKitTheme {
  static const UiColors lightUiColors = UiColors.light();
  static const UiColors darkUiColors = UiColors.dark();

  static const UiTextStyles uiTextStyles = UiTextStyles();

  static ColorScheme lightColorScheme() => ColorScheme.fromSwatch(
        backgroundColor: lightUiColors.backgroundPrimaryColor,
      ).copyWith(
        primary: lightUiColors.primaryColor,
        secondary: lightUiColors.secondaryColor,
        error: lightUiColors.errorColor,
        onPrimary: lightUiColors.primaryTextColor,
        onSecondary: lightUiColors.secondaryTextColor,
      );

  static ColorScheme darkColorScheme() => ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        backgroundColor: darkUiColors.backgroundPrimaryColor,
      ).copyWith(
        primary: darkUiColors.primaryColor,
        secondary: darkUiColors.secondaryColor,
        error: darkUiColors.errorColor,
        onPrimary: darkUiColors.primaryTextColor,
        onSecondary: darkUiColors.secondaryTextColor,
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
