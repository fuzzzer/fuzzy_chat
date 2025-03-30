import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FuzzyErrorPageBuilder extends StatelessWidget {
  final String? message;
  final bool hasAutomaticBackButton;

  const FuzzyErrorPageBuilder({
    super.key,
    this.message,
    this.hasAutomaticBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = context.fuzzyChatLocalizations;

    return FuzzyScaffold(
      hasAutomaticBackButton: hasAutomaticBackButton,
      body: Center(
        child: Text(
          message ?? localizations.unexpectedFailureOccuredPleaseContactUs,
          style: uiTextStyles.bodyBold16.copyWith(
            color: uiColors.errorColor,
          ),
        ),
      ),
    );
  }
}
