import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class HorizontalProgressBar extends StatelessWidget {
  const HorizontalProgressBar({
    super.key,
    this.alignment = Alignment.centerLeft,
    this.thickness = 50,
    this.width,
    this.progressColor,
    required this.progress,
  });

  final Alignment alignment;
  final double thickness;
  final double? width;
  final Color? progressColor;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    const borderWidth = 2.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final realWidth = width ?? constraints.maxWidth;

        return SizedBox(
          width: realWidth,
          height: thickness,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: borderWidth,
                color: uiColors.backgroundSecondaryColor,
              ),
            ),
            child: Align(
              alignment: alignment,
              child: SizedBox(
                width: realWidth * progress,
                height: thickness - borderWidth * 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: progressColor ?? uiColors.backgroundSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
