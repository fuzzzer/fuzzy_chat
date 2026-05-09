import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

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
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        suffixIcon: suffixIcon,
        fillColor: uiColors.secondaryColor,
        focusColor: uiColors.focusColor,
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
