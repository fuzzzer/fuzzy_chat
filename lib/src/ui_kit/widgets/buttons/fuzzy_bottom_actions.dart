import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FuzzyActionsRow extends StatelessWidget {
  const FuzzyActionsRow({
    super.key,
    this.hasBackButton = true,
    this.mainActionLabel,
    this.onMainActionPressed,
    this.customActions = const [],
    this.isMainActionEnabled = true,
  });

  final bool hasBackButton;
  final String? mainActionLabel;
  final void Function()? onMainActionPressed;
  final List<Widget> customActions;
  final bool isMainActionEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (hasBackButton) const FuzzyBackButton(),
        if (onMainActionPressed != null) const SizedBox(width: 8),
        ...customActions.map(
          (action) => const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
            ),
          ),
        ),
        if (onMainActionPressed != null) const SizedBox(width: 8),
        if (onMainActionPressed != null)
          Expanded(
            child: FuzzyButton(
              text: mainActionLabel ?? '',
              onTap: onMainActionPressed!,
              isEnabled: isMainActionEnabled,
            ),
          ),
      ],
    );
  }
}
