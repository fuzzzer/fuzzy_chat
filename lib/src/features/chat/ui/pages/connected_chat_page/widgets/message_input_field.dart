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

    final localizations = FuzzyChatLocalizations.of(context)!;

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
            child: Text(
              isEncrypting ? localizations.encrypting : localizations.decrypting,
              style: uiTextStyles.body16.copyWith(
                color: uiColors.secondaryColor,
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
                  child: Container(
                    height: height,
                    width: 60,
                    decoration: BoxDecoration(
                      color: uiColors.focusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.send,
                      color: uiColors.backgroundPrimaryColor,
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
