import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:share_plus/share_plus.dart';

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
  bool hasJustCopied = false;

  String _prepareEncrypredMessage(String encryptedMessage) => '$fuzzIdentificator$encryptedMessage';

  void _copyMessage({
    required String encryptedMessage,
    required FuzzyChatLocalizations localizations,
  }) {
    if (hasJustCopied) return;

    setState(() {
      hasJustCopied = true;
    });

    Clipboard.setData(
      ClipboardData(
        text: _prepareEncrypredMessage(encryptedMessage),
      ),
    ).then((_) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            localizations.copiedToTheClipboard,
          ),
        ),
      );
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          hasJustCopied = false;
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

    final encryptedMessage = widget.message.encryptedMessage;

    return InkWell(
      splashColor: uiColors.backgroundPrimaryColor,
      onLongPress: () {
        _copyMessage(
          encryptedMessage: encryptedMessage,
          localizations: localizations,
        );
      },
      child: Container(
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
              child: FuzzyOverlaySpawner(
                splashRadius: borderRadius,
                spawnedChildBuilder: (context, closeOverlay) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: uiColors.focusColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        TextAction(
                          hasLeftBorder: true,
                          label: localizations.copy,
                          onTap: () {
                            _copyMessage(
                              encryptedMessage: encryptedMessage,
                              localizations: localizations,
                            );

                            closeOverlay();
                          },
                        ),
                        const SizedBox(width: 1),
                        TextAction(
                          hasRightBorder: true,
                          label: localizations.share,
                          onTap: () {
                            final preparedEncryptedMessage = _prepareEncrypredMessage(encryptedMessage);

                            Share.share(preparedEncryptedMessage);

                            closeOverlay();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    encryptedMessage,
                    style: uiTextStyles.body16.copyWith(
                      color: uiColors.backgroundPrimaryColor,
                    ),
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
