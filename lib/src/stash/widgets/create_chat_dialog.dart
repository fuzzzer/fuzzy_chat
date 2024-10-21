import 'package:flutter/material.dart';

void showCreateChatOptions(BuildContext context) {
  // ignore: inference_failure_on_function_invocation
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create New Chat'),
            onTap: () {
              //_createNewChat();
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('Import Invitation'),
            onTap: () {
              //_importInvitation();
            },
          ),
        ],
      );
    },
  );
}
