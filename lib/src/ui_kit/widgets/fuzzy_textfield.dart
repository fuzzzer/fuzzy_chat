import 'package:flutter/material.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';

class FuzzyTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final EdgeInsets scrollPadding;
  final String? hintText;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final String? helperText;
  final Widget? suffixIcon;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final int? minLines;
  final bool expands;

  const FuzzyTextField({
    required this.labelText,
    super.key,
    this.controller,
    this.onChanged,
    this.scrollPadding = const EdgeInsets.all(20),
    this.hintText,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.helperText,
    this.suffixIcon,
    this.onSubmitted,
    this.textInputAction,
    this.minLines,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    final fuzzzyColors = context.fuzzzyColors;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      scrollPadding: scrollPadding,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        suffixIcon: suffixIcon,
        fillColor: fuzzzyColors.surface,
        focusColor: fuzzzyColors.focus,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
