import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isEncrypting;

  const MessageInputField({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isEncrypting,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

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
              isEncrypting ? localizations.enrypting : localizations.decrypting,
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
