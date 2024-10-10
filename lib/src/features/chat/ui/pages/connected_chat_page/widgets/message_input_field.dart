import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onEncryptTap;
  final VoidCallback onDecryptTap;

  const MessageInputField({
    required this.controller,
    required this.focusNode,
    required this.onEncryptTap,
    required this.onDecryptTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;

    const height = 200.0;
    const aroundTextFieldPadding = 8.0;

    const gapBetweenButtons = 8.0;

    final fullWidth = MediaQuery.of(context).size.width;

    return Container(
      height: height + 2,
      color: uiColors.backgroundPrimaryColor,
      child: Column(
        children: [
          Container(
            height: 2,
            width: fullWidth,
            color: Colors.black,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(aroundTextFieldPadding),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: 7,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Text Goes here...',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: height / 2 - gapBetweenButtons / 2,
                    child: InkWell(
                      onTap: onDecryptTap,
                      child: const Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.no_encryption,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: gapBetweenButtons),
                  SizedBox(
                    width: 60,
                    height: height / 2 - gapBetweenButtons / 2,
                    child: InkWell(
                      onTap: onEncryptTap,
                      child: const Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
