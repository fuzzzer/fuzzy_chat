import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';

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
  bool isExpanded = false;
  bool isExpandable = false;
  bool showEncrypted = true;

  String _prepareEncrypredMessage(String encryptedMessage) => '$fuzzIdentificator$encryptedMessage';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _checkIfIsExpandable(widget.message.encryptedMessage);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SentMessageArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.encryptedMessage != widget.message.encryptedMessage) {
      _checkIfIsExpandable(widget.message.encryptedMessage);
    }
  }

  void _checkIfIsExpandable(String message) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: message,
      ),
      maxLines: 4,
      textDirection: TextDirection.ltr,
    )..layout(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      );

    setState(() {
      isExpandable = textPainter.didExceedMaxLines;
    });
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _toggleHide(bool status) {
    setState(() {
      showEncrypted = status;
    });
  }

  void _copyMessage({
    required String encryptedMessage,
    required FuzzyChatLocalizations localizations,
  }) {
    if (hasJustCopied) return;

    setState(() {
      hasJustCopied = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          hasJustCopied = false;
        });
      }
    });

    Clipboard.setData(
      ClipboardData(
        text: _prepareEncrypredMessage(encryptedMessage),
      ),
    ).then((_) async {
      FuzzySnackbar.show(label: localizations.copiedToTheClipboard);

      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? true) {
        await Vibration.vibrate();
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

    return GestureDetector(
      onPanUpdate: (details) {
        final swipedLeftToRight = details.delta.dx > 0;
        final swipedRightToLeft = details.delta.dx < 0;
        if (swipedLeftToRight) {
          _toggleHide(true);
        } else if (swipedRightToLeft) {
          _toggleHide(false);
        }
      },
      child: InkWell(
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
                child: Stack(
                  children: [
                    Padding(
                      padding: isExpandable ? const EdgeInsets.only(bottom: 12) : EdgeInsets.zero,
                      child: FuzzyOverlaySpawner(
                        splashColor: uiColors.backgroundPrimaryColor,
                        splashRadius: borderRadius,
                        offset: (!showEncrypted && widget.message.decryptedMessage.length < 10)
                            ? const Offset(-140, 8)
                            : const Offset(24, -24),
                        spawnedChildBuilder: (context, closeOverlay) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: uiColors.focusColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                        onLongPress: () {
                          _copyMessage(
                            encryptedMessage: encryptedMessage,
                            localizations: localizations,
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: AnimatedSize(
                            duration: const Duration(
                              milliseconds: 300,
                            ),
                            curve: Curves.easeIn,
                            child: Text(
                              showEncrypted ? encryptedMessage : widget.message.decryptedMessage,
                              maxLines: isExpanded ? null : 4,
                              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                              style: uiTextStyles.body16.copyWith(
                                color: uiColors.backgroundPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isExpandable)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _toggleExpand,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 24,
                                color: Colors.white.withOpacity(0),
                              ),
                              Icon(
                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                size: 24,
                                color: uiColors.backgroundPrimaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
