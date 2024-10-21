// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../text_styles/text_styles.dart';

class UiTextStyles extends ThemeExtension<UiTextStyles> {
  final TextStyle maxBold72;
  final TextStyle max72;
  final TextStyle largeDisplayBold32;
  final TextStyle largeDisplay32;
  final TextStyle displayBold28;
  final TextStyle display28;
  final TextStyle bodyLargeBold20;
  final TextStyle bodyLarge20;
  final TextStyle bodyBold16;
  final TextStyle body16;
  final TextStyle bodySmallBold12;
  final TextStyle bodySmall12;

  const UiTextStyles({
    this.maxBold72 = UiKitTextStyles.maxBold72,
    this.max72 = UiKitTextStyles.max72,
    this.largeDisplayBold32 = UiKitTextStyles.largeDisplayBold32,
    this.largeDisplay32 = UiKitTextStyles.largeDisplay32,
    this.displayBold28 = UiKitTextStyles.displayBold28,
    this.display28 = UiKitTextStyles.display28,
    this.bodyLargeBold20 = UiKitTextStyles.bodyLargeBold20,
    this.bodyLarge20 = UiKitTextStyles.bodyLarge20,
    this.bodyBold16 = UiKitTextStyles.bodyBold16,
    this.body16 = UiKitTextStyles.body16,
    this.bodySmallBold12 = UiKitTextStyles.bodySmallBold12,
    this.bodySmall12 = UiKitTextStyles.bodySmall12,
  });

  UiTextStyles apply({
    Color? color,
    double fontSizeFactor = 1,
  }) {
    return UiTextStyles(
      maxBold72: UiKitTextStyles.maxBold72.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      max72: UiKitTextStyles.max72.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      largeDisplayBold32: UiKitTextStyles.largeDisplayBold32.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      largeDisplay32: UiKitTextStyles.largeDisplay32.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      displayBold28: UiKitTextStyles.displayBold28.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      display28: UiKitTextStyles.display28.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodyLargeBold20: UiKitTextStyles.bodyLargeBold20.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodyLarge20: UiKitTextStyles.bodyLarge20.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodyBold16: UiKitTextStyles.bodyBold16.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      body16: UiKitTextStyles.body16.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodySmallBold12: UiKitTextStyles.bodySmallBold12.apply(
        color: color,
        fontSizeFactor: fontSizeFactor,
      ),
      bodySmall12: UiKitTextStyles.bodySmall12.apply(
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
      maxBold72: TextStyle.lerp(maxBold72, other.maxBold72, t)!,
      max72: TextStyle.lerp(max72, other.max72, t)!,
      largeDisplayBold32: TextStyle.lerp(largeDisplayBold32, other.largeDisplayBold32, t)!,
      largeDisplay32: TextStyle.lerp(largeDisplay32, other.largeDisplay32, t)!,
      displayBold28: TextStyle.lerp(displayBold28, other.displayBold28, t)!,
      display28: TextStyle.lerp(display28, other.display28, t)!,
      bodyLargeBold20: TextStyle.lerp(bodyLargeBold20, other.bodyLargeBold20, t)!,
      bodyLarge20: TextStyle.lerp(bodyLarge20, other.bodyLarge20, t)!,
      bodyBold16: TextStyle.lerp(bodyBold16, other.bodyBold16, t)!,
      body16: TextStyle.lerp(body16, other.body16, t)!,
      bodySmallBold12: TextStyle.lerp(bodySmallBold12, other.bodySmallBold12, t)!,
      bodySmall12: TextStyle.lerp(bodySmall12, other.bodySmall12, t)!,
    );
  }

  @override
  UiTextStyles copyWith({
    TextStyle? maxBold72,
    TextStyle? max72,
    TextStyle? largeDisplayBold32,
    TextStyle? largeDisplay32,
    TextStyle? displayBold28,
    TextStyle? display28,
    TextStyle? bodyLargeBold20,
    TextStyle? bodyLarge20,
    TextStyle? bodyBold16,
    TextStyle? body16,
    TextStyle? bodySmallBold12,
    TextStyle? bodySmall12,
  }) {
    return UiTextStyles(
      maxBold72: maxBold72 ?? this.maxBold72,
      max72: max72 ?? this.max72,
      largeDisplayBold32: largeDisplayBold32 ?? this.largeDisplayBold32,
      largeDisplay32: largeDisplay32 ?? this.largeDisplay32,
      displayBold28: displayBold28 ?? this.displayBold28,
      display28: display28 ?? this.display28,
      bodyLargeBold20: bodyLargeBold20 ?? this.bodyLargeBold20,
      bodyLarge20: bodyLarge20 ?? this.bodyLarge20,
      bodyBold16: bodyBold16 ?? this.bodyBold16,
      body16: body16 ?? this.body16,
      bodySmallBold12: bodySmallBold12 ?? this.bodySmallBold12,
      bodySmall12: bodySmall12 ?? this.bodySmall12,
    );
  }
}
