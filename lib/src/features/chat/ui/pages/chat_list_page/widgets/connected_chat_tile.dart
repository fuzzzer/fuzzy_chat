import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class ConnectedChatTile extends StatelessWidget {
  final String name;
  final void Function() onTap;
  final void Function() onLongPress;

  const ConnectedChatTile({
    required this.name,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = context.fuzzyChatLocalizations;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      color: uiColors.backgroundSecondaryColor,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: const Icon(
          Icons.lock,
          size: 32,
          color: Color.fromARGB(210, 59, 103, 60),
        ),
        title: Text(
          name,
          style: uiTextStyles.body16,
        ),
        subtitle: Text(
          localizations.tapToViewChat,
          style: uiTextStyles.bodySmall12,
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 32,
          color: uiColors.secondaryColor,
        ),
      ),
    );
  }
}
