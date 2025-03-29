import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FileDecryptionProgressDisplay extends StatelessWidget {
  const FileDecryptionProgressDisplay({
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

    return FileDecriptionCubitBuilder(
      builder: (context, state) {
        if (state.currentProcessingFile == null) {
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
                  alignment: Alignment.centerRight,
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
