import 'package:flutter/material.dart';

import '../../text_styles/text_styles.dart';

class UiTextStyles extends ThemeExtension<UiTextStyles> {
  final TextStyle maxBold;
  final TextStyle max;
  final TextStyle largeDisplayBold;
  final TextStyle largeDisplay;
  final TextStyle displayBold;
  final TextStyle display;
  final TextStyle bodyLargeBold;
  final TextStyle bodyLarge;
  final TextStyle bodyBold;
  final TextStyle body;
  final TextStyle bodySmallBold;
  final TextStyle bodySmall;

  const UiTextStyles({
    this.maxBold = UiKitTextStyles.maxBold,
    this.max = UiKitTextStyles.max,
    this.largeDisplayBold = UiKitTextStyles.largeDisplayBold,
    this.largeDisplay = UiKitTextStyles.largeDisplay,
    this.displayBold = UiKitTextStyles.displayBold,
    this.display = UiKitTextStyles.display,
    this.bodyLargeBold = UiKitTextStyles.bodyLargeBold,
    this.bodyLarge = UiKitTextStyles.bodyLarge,
    this.bodyBold = UiKitTextStyles.bodyBold,
    this.body = UiKitTextStyles.body,
    this.bodySmallBold = UiKitTextStyles.bodySmallBold,
    this.bodySmall = UiKitTextStyles.bodySmall,
  });

  UiTextStyles apply({
    Color? color,
    double fontSizeFactor = 1,
  }) {
    return UiTextStyles(
      maxBold: UiKitTextStyles.maxBold.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      max: UiKitTextStyles.max.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      largeDisplayBold: UiKitTextStyles.largeDisplayBold.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      largeDisplay: UiKitTextStyles.largeDisplay.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      displayBold: UiKitTextStyles.displayBold.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      display: UiKitTextStyles.display.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodyLargeBold: UiKitTextStyles.bodyLargeBold.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodyLarge: UiKitTextStyles.bodyLarge.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodyBold: UiKitTextStyles.bodyBold.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      body: UiKitTextStyles.body.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodySmallBold: UiKitTextStyles.bodySmallBold.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodySmall: UiKitTextStyles.bodySmall.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
    );
  }

  @override
  ThemeExtension<UiTextStyles> lerp(ThemeExtension<UiTextStyles>? other, double t) {
    if (other is! UiTextStyles) {
      return this;
    }

    return UiTextStyles(
      maxBold: TextStyle.lerp(maxBold, other.maxBold, t)!,
      max: TextStyle.lerp(max, other.max, t)!,
      largeDisplayBold: TextStyle.lerp(largeDisplayBold, other.largeDisplayBold, t)!,
      largeDisplay: TextStyle.lerp(largeDisplay, other.largeDisplay, t)!,
      displayBold: TextStyle.lerp(displayBold, other.displayBold, t)!,
      display: TextStyle.lerp(display, other.display, t)!,
      bodyLargeBold: TextStyle.lerp(bodyLargeBold, other.bodyLargeBold, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodyBold: TextStyle.lerp(bodyBold, other.bodyBold, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmallBold: TextStyle.lerp(bodySmallBold, other.bodySmallBold, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
    );
  }

  @override
  UiTextStyles copyWith({
    TextStyle? maxBold,
    TextStyle? max,
    TextStyle? largeDisplayBold,
    TextStyle? largeDisplay,
    TextStyle? displayBold,
    TextStyle? display,
    TextStyle? bodyLargeBold,
    TextStyle? bodyLarge,
    TextStyle? bodyBold,
    TextStyle? body,
    TextStyle? bodySmallBold,
    TextStyle? bodySmall,
  }) {
    return UiTextStyles(
      maxBold: maxBold ?? this.maxBold,
      max: max ?? this.max,
      largeDisplayBold: largeDisplayBold ?? this.largeDisplayBold,
      largeDisplay: largeDisplay ?? this.largeDisplay,
      displayBold: displayBold ?? this.displayBold,
      display: display ?? this.display,
      bodyLargeBold: bodyLargeBold ?? this.bodyLargeBold,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyBold: bodyBold ?? this.bodyBold,
      body: body ?? this.body,
      bodySmallBold: bodySmallBold ?? this.bodySmallBold,
      bodySmall: bodySmall ?? this.bodySmall,
    );
  }
}
