import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final service = sl.get<PasswordStrengthService>();
    final strength = service.assess(password);

    Color getLevelColor() {
      switch (strength.level) {
        case PasswordStrengthLevel.weak:
          return Colors.red;
        case PasswordStrengthLevel.fair:
          return Colors.orange;
        case PasswordStrengthLevel.good:
          return Colors.yellow.shade700;
        case PasswordStrengthLevel.strong:
          return Colors.green;
      }
    }

    final color = getLevelColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentContextLocalization.vaultPasswordStrength,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.fuzzzyColors.inkMute,
                  ),
            ),
            Text(
              '${strength.level.name.toUpperCase()} ${strength.score}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength.score / 100.0,
            backgroundColor: context.fuzzzyColors.surface,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
