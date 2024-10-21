import 'package:flutter/material.dart';

class InvitedChatTile extends StatelessWidget {
  final String name;
  final void Function() onTap;

  const InvitedChatTile({
    required this.name,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.hourglass_empty,
          color: Colors.orange,
        ),
        title: Text(name),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}
