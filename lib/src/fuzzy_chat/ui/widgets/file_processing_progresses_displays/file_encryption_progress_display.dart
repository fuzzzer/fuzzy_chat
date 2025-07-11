import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FileEncryptionProgressDisplay extends StatelessWidget {
  const FileEncryptionProgressDisplay({
    super.key,
    required this.chatId,
  });

  static const height = 30.0;

  final String chatId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    const borderWidth = 2.0;

    return FileEncriptionCubitBuilder(
      builder: (context, state) {
        if (state.currentProcessingFile?.chatId != chatId) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: height,
          child: Row(
            children: [
              Container(
                width: 50,
                height: height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: uiColors.backgroundSecondaryColor,
                    width: borderWidth,
                  ),
                ),
                child: Center(
                  child: Text(
                    state.getToBeProcessedFilesByChatId(chatId).length.toString(),
                    style: uiTextStyles.bodyLargeBold20.copyWith(
                      color: uiColors.secondaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: HorizontalProgressBar(
                  thickness: height,
                  progress: state.progress,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
