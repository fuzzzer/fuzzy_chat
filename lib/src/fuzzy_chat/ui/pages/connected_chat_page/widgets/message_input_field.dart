import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final SelectedFilesCallback onFilesSelected;
  final List<String>? selectedFilePaths;
  final bool isEncrypting;
  final String chatId;

  const MessageInputField({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onFilesSelected,
    required this.isEncrypting,
    required this.selectedFilePaths,
    required this.chatId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = context.fuzzyChatLocalizations;

    const height = 200.0;
    const aroundTextFieldPadding = 8.0;

    final fullWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height + 2,
      color: uiColors.backgroundPrimaryColor,
      child: Column(
        children: [
          Container(
            height: 2,
            width: fullWidth,
            color: uiColors.backgroundSecondaryColor,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Text(
                  isEncrypting ? localizations.encrypting : localizations.decrypting,
                  key: ValueKey<bool>(isEncrypting),
                  style: uiTextStyles.body16.copyWith(
                    color: isEncrypting ? uiColors.diffColor : uiColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 2,
            width: fullWidth,
            color: uiColors.backgroundSecondaryColor,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(aroundTextFieldPadding),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: 7,
                      decoration: InputDecoration.collapsed(
                        hintText: '${localizations.textGoesHere}...',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: FileSelectorWidget(
                      onSelected: onFilesSelected,
                      selectedFilePaths: selectedFilePaths,
                      allowMultiple: true,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onSend,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: height,
                    width: 60,
                    decoration: BoxDecoration(
                      color: uiColors.focusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.send,
                      color: isEncrypting ? const Color(0xFF18181A) : uiColors.backgroundPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
