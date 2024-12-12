import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FuzzyToolbox extends StatelessWidget {
  final List<Widget> children;

  const FuzzyToolbox({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    return Material(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      color: uiColors.backgroundSecondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
