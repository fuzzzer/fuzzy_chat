import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class ChatListErrorContent extends StatelessWidget {
  final String? message;

  const ChatListErrorContent({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = context.fuzzyChatLocalizations;

    return Center(
      child: Text(
        message ?? localizations.failedToLoadChats,
        style: uiTextStyles.bodyBold16.copyWith(
          color: uiColors.errorColor,
        ),
      ),
    );
  }
}
