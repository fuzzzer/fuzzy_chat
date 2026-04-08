import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class ReceivedTextMessageArea extends StatelessWidget {
  final MessageData message;

  const ReceivedTextMessageArea({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final isStrict = sl.get<PreferencesService>().copySecurityLevel == CopySecurityLevel.strict;

    final textStyle = uiTextStyles.body16.copyWith(
      color: uiColors.primaryTextColor,
    );

    final decoration = BoxDecoration(
      color: uiColors.backgroundSecondaryColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.maxFinite,
        child: Align(
          alignment: Alignment.centerLeft,
          child: isStrict
              ? InkWell(
                  onLongPress: () {
                    CopyGuard.copyPlaintext(
                      context: context,
                      textToCopy: message.decryptedMessage,
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: decoration,
                    child: Text(
                      message.decryptedMessage,
                      style: textStyle,
                    ),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: decoration,
                  child: SelectableText(
                    message.decryptedMessage,
                    style: textStyle,
                  ),
                ),
        ),
      ),
    );
  }
}
