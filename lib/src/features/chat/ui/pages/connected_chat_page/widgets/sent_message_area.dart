import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import '../../../../data/data.dart';

class SentMessageArea extends StatelessWidget {
  final MessageData message;

  const SentMessageArea({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: uiColors.focusColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: SelectableText(
            message.encryptedMessage,
            style: uiTextStyles.body16.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
