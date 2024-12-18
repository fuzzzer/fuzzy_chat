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
    this.maxLines,
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
      scrollPadding: scrollPadding,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
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
