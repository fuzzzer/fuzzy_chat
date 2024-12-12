import 'package:flutter/material.dart';

import '../../ui_kit.dart';

class FuzzyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const FuzzyButton({
    required this.text,
    required this.onTap,
    super.key,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isEnabled ? uiColors.focusColor : uiColors.focusColor.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: textColor ?? uiColors.backgroundPrimaryColor,
                ),
              if (icon != null) const SizedBox(width: 8),
              Text(
                text,
                style: uiTextStyles.bodyBold16.copyWith(
                  color: uiColors.backgroundPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
