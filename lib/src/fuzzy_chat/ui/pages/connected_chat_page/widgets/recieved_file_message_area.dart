import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';

class ReceivedFileMessageArea extends StatefulWidget {
  final MessageData message;

  const ReceivedFileMessageArea({
    required this.message,
    super.key,
  });

  @override
  State<ReceivedFileMessageArea> createState() =>
      _ReceivedFileMessageAreaState();
}

class _ReceivedFileMessageAreaState extends State<ReceivedFileMessageArea> {
  String fileName = '';

  @override
  void initState() {
    super.initState();

    final parts = widget.message.encryptedMessage.split('/');
    fileName = parts.isNotEmpty ? parts.last : '';
  }

  void _openDecryptedFileDirectory({
    required String encryptedMessage,
  }) {
    final filePath = encryptedMessage.replaceAll(fuzzIdentificator, '');

    DeviceFileInteractor.revealFile(filePath);
  }

  void _openDecryptedFile({
    required String encryptedMessage,
  }) {
    final filePath = encryptedMessage.replaceAll(fuzzIdentificator, '');

    DeviceFileInteractor.openFile(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final fuzzzyTextStyles = context.fuzzzyTextStyles;
    final fuzzzyColors = context.fuzzzyColors;

    final localizations = context.fuzzyChatLocalizations;

    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onLongPress: () {
          _openDecryptedFile(
            encryptedMessage: widget.message.encryptedMessage,
          );
        },
        child: SizedBox(
          width: double.maxFinite,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FuzzyOverlaySpawner(
              splashColor: fuzzzyColors.ground,
              splashRadius: borderRadius,
              offset: const Offset(150, -20),
              spawnedChildBuilder: (context, closeOverlay) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: fuzzzyColors.focus,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextAction(
                        hasLeftBorder: true,
                        label: localizations.show,
                        onTap: () {
                          _openDecryptedFileDirectory(
                            encryptedMessage: widget.message.encryptedMessage,
                          );
                        },
                      ),
                      const SizedBox(width: 2),
                      TextAction(
                        label: localizations.open,
                        onTap: () {
                          _openDecryptedFile(
                            encryptedMessage: widget.message.encryptedMessage,
                          );
                        },
                      ),
                      const SizedBox(width: 2),
                      TextAction(
                        label: localizations.shareFile,
                        onTap: () {
                          final filePath = widget.message.encryptedMessage
                              .replaceAll(fuzzIdentificator, '');
                          DeviceFileInteractor.shareFile(filePath,
                              context: context,);
                          closeOverlay();
                        },
                      ),
                      const SizedBox(width: 2),
                      TextAction(
                        label: '🔗',
                        onTap: () {
                          final link = FuzzyLinkGenerator.generateFuzzLink(
                            widget.message.chatId,
                            widget.message.encryptedMessage,
                          );
                          final preparedFuzz =
                              '$fuzzIdentificator${widget.message.encryptedMessage}';
                          final shareable =
                              FuzzyLinkGenerator.generateShareableContent(
                            link: link,
                            rawFuzz: preparedFuzz,
                            type: FuzzyLinkType.fuzz,
                          );
                          ShareHelper.share(shareable, context: context);
                          closeOverlay();
                        },
                      ),
                      const SizedBox(width: 2),
                      TextAction(
                        label: localizations.copyAsLink,
                        onTap: () {
                          final link = FuzzyLinkGenerator.generateFuzzLink(
                            widget.message.chatId,
                            widget.message.encryptedMessage,
                          );
                          Clipboard.setData(ClipboardData(text: link));
                          FuzzzyToast.show(context,
                              message: localizations.linkCopiedToClipboard,);
                          closeOverlay();
                        },
                      ),
                      const SizedBox(width: 2),
                      TextAction(
                        hasRightBorder: true,
                        label: localizations.copy,
                        onTap: () {
                          final filePath = widget.message.encryptedMessage
                              .replaceAll(fuzzIdentificator, '');
                          Clipboard.setData(ClipboardData(text: filePath));
                          FuzzzyToast.show(context,
                              message: localizations.copiedToTheClipboard,);
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
                decoration: BoxDecoration(
                  color: fuzzzyColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  widget.message.encryptedMessage,
                  style: fuzzzyTextStyles.body.copyWith(
                    color: fuzzzyColors.ink,
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
