import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class InvitedChatTile extends StatelessWidget {
  final String name;
  final void Function() onTap;
  final void Function() onLongPress;

  const InvitedChatTile({
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

    final localizations = FuzzyChatLocalizations.of(context)!;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      color: uiColors.backgroundSecondaryColor.withOpacity(0.4),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: const Icon(
          Icons.hourglass_empty,
          size: 32,
          color: Color.fromARGB(135, 255, 153, 0),
        ),
        title: Text(
          name,
          style: uiTextStyles.body16,
        ),
        subtitle: Text(
          localizations.waitingForAcceptance,
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
