import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';

class SentMessageArea extends StatefulWidget {
  final MessageData message;

  const SentMessageArea({
    required this.message,
    super.key,
  });

  @override
  State<SentMessageArea> createState() => _SentMessageAreaState();
}

class _SentMessageAreaState extends State<SentMessageArea> {
  bool hasJustCopeied = false;

  void _copyMessage({
    required String encryptedMessage,
    required FuzzyChatLocalizations localizations,
  }) {
    if (hasJustCopeied) return;

    setState(() {
      hasJustCopeied = true;
    });

    Clipboard.setData(
      ClipboardData(
        text: '$fuzzIdentificator$encryptedMessage',
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

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          hasJustCopeied = false;
        });
      }
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

    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: uiColors.secondaryColor,
            ),
            child: InkWell(
              borderRadius: borderRadius,
              splashColor: uiColors.backgroundPrimaryColor,
              onLongPress: () {
                _copyMessage(
                  encryptedMessage: widget.message.encryptedMessage,
                  localizations: localizations,
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.message.encryptedMessage,
                  style: uiTextStyles.body16.copyWith(
                    color: uiColors.backgroundPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
