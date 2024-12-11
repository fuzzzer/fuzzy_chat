import 'package:flutter/material.dart';

class FuzzySnackbarData {
  final String? label;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final double? width;
  final double? elevation;
  final Widget? leading;
  final Widget? content;
  final Duration? duration;

  const FuzzySnackbarData({
    this.label,
    this.labelStyle,
    this.backgroundColor,
    this.width,
    this.elevation,
    this.leading,
    this.content,
    this.duration,
  });
}
