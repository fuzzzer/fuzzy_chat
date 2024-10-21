import 'package:flutter/material.dart';

class ConnectedChatTile extends StatelessWidget {
  final String name;
  final void Function() onTap;

  const ConnectedChatTile({
    required this.name,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(
          Icons.lock,
          color: Colors.green,
        ),
        title: Text(name),
        subtitle: const Text(
          'Tap to view chat',
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}
