import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import '../../../../data/data.dart';

class MessageArea extends StatelessWidget {
  final MessageData message;

  const MessageArea({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isSent ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: message.isSent ? const Radius.circular(12) : Radius.zero,
              bottomRight: message.isSent ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Text(
            message.fuzzyMessage,
            style: uiTextStyles.body16.copyWith(
              color: message.isSent ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
