import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class TextAction extends StatelessWidget {
  const TextAction({
    super.key,
    required this.onTap,
    required this.label,
    this.hasLeftBorder = false,
    this.hasRightBorder = false,
  });
  final void Function() onTap;
  final String label;
  final bool hasLeftBorder;
  final bool hasRightBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    const defaultRadius = Radius.circular(12);

    final borderRadius = BorderRadius.only(
      topLeft: hasLeftBorder ? defaultRadius : Radius.zero,
      bottomLeft: hasLeftBorder ? defaultRadius : Radius.zero,
      topRight: hasRightBorder ? defaultRadius : Radius.zero,
      bottomRight: hasRightBorder ? defaultRadius : Radius.zero,
    );

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: uiColors.backgroundSecondaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Text(
            label,
            style: uiTextStyles.bodyBold16,
          ),
        ),
      ),
    );
  }
}
