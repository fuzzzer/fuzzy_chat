import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';

final _copyDebouncer = Debouncer(milliseconds: 500);

class SentMessageArea extends StatelessWidget {
  final MessageData message;

  const SentMessageArea({
    required this.message,
    super.key,
  });

  static void _copyMessage({
    required String encryptedMessage,
    required FuzzyChatLocalizations localizations,
  }) {
    _copyDebouncer.run(() {
      Clipboard.setData(
        ClipboardData(
          text: encryptedMessage,
        ),
      ).then((value) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              localizations.copiedToTheClipboard,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = FuzzyChatLocalizations.of(context)!;

    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );

    return InkWell(
      borderRadius: borderRadius,
      onTap: () {
        _copyMessage(
          encryptedMessage: message.encryptedMessage,
          localizations: localizations,
        );
      },
      child: Container(
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
              color: uiColors.secondaryColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              message.encryptedMessage,
              style: uiTextStyles.body16.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
