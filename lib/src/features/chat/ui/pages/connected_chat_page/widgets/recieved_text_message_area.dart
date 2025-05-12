import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import '../../../../data/data.dart';

class ReceivedTextMessageArea extends StatelessWidget {
  final MessageData message;

  const ReceivedTextMessageArea({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.maxFinite,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: SelectableText(
              message.decryptedMessage,
              style: uiTextStyles.body16.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
