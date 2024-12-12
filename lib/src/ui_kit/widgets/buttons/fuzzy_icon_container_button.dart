import 'package:flutter/material.dart';

import '../../ui_kit.dart';

class FuzzyIconContainerButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;

  const FuzzyIconContainerButton({
    required this.onTap,
    super.key,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor ?? uiColors.secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? uiColors.backgroundPrimaryColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
