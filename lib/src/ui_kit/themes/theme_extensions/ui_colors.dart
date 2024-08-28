import 'package:flutter/material.dart';

import '../../colors/colors.dart';

class UiColors extends ThemeExtension<UiColors> {
  final Color primaryColor;
  final Color focusColor;
  final Color secondaryColor;
  final Color errorColor;
  final Color backgroundPrimaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const UiColors({
    this.primaryColor = UiKitColors.primaryColor,
    this.focusColor = UiKitColors.focusColor,
    this.secondaryColor = UiKitColors.secondaryColor,
    this.errorColor = UiKitColors.errorColor,
    this.backgroundPrimaryColor = UiKitColors.backgroundPrimaryColor,
    this.primaryTextColor = UiKitColors.primaryTextColor,
    this.secondaryTextColor = UiKitColors.secondaryTextColor,
  });

  const UiColors.light({
    this.primaryColor = UiKitColors.primaryColor,
    this.focusColor = UiKitColors.focusColor,
    this.secondaryColor = UiKitColors.secondaryColor,
    this.errorColor = UiKitColors.errorColor,
    this.backgroundPrimaryColor = UiKitColors.backgroundPrimaryColor,
    this.primaryTextColor = UiKitColors.primaryTextColor,
    this.secondaryTextColor = UiKitColors.secondaryTextColor,
  });

  const UiColors.dark({
    this.primaryColor = UiKitColors.primaryColor,
    this.focusColor = UiKitColors.focusColor,
    this.secondaryColor = UiKitColors.secondaryColor,
    this.errorColor = UiKitColors.errorColor,
    this.backgroundPrimaryColor = UiKitColors.backgroundPrimaryColor,
    this.primaryTextColor = UiKitColors.primaryTextColor,
    this.secondaryTextColor = UiKitColors.secondaryTextColor,
  });

  @override
  ThemeExtension<UiColors> lerp(ThemeExtension<UiColors>? other, double t) {
    if (other is! UiColors) {
      return this;
    }

    return UiColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      focusColor: Color.lerp(focusColor, other.focusColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      backgroundPrimaryColor: Color.lerp(backgroundPrimaryColor, other.backgroundPrimaryColor, t)!,
      primaryTextColor: Color.lerp(primaryTextColor, other.primaryTextColor, t)!,
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
    );
  }

  @override
  UiColors copyWith({
    Color? primaryColor,
    Color? focusColor,
    Color? secondaryColor,
    Color? errorColor,
    Color? backgroundPrimaryColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
  }) {
    return UiColors(
      primaryColor: primaryColor ?? this.primaryColor,
      focusColor: focusColor ?? this.focusColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      errorColor: errorColor ?? this.errorColor,
      backgroundPrimaryColor: backgroundPrimaryColor ?? this.backgroundPrimaryColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
    );
  }
}
