import 'package:flutter/material.dart';
import '../../../../chat.dart';
import 'message_area.dart';

class MessageListSliver extends StatelessWidget {
  final List<MessageData> messages;

  const MessageListSliver({
    required this.messages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final message = messages[messages.length - 1 - index];
          return MessageArea(message: message);
        },
        childCount: messages.length,
      ),
    );
  }
}
