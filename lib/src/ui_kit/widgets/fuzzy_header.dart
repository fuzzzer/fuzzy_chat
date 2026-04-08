import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

class FuzzyHeader extends StatelessWidget {
  final String title;

  final TextAlign textAlign;
  final Widget? leftAction;
  final Widget? rightAction;

  const FuzzyHeader({
    required this.title,
    super.key,
    this.textAlign = TextAlign.center,
    this.leftAction,
    this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 32,
            child: leftAction,
          ),
          const Spacer(),
          Text(
            title,
            style: uiTextStyles.bodyLarge20,
            textAlign: textAlign,
          ),
          const Spacer(),
          SizedBox.square(
            dimension: 32,
            child: rightAction,
          ),
        ],
      ),
    );
  }
}
