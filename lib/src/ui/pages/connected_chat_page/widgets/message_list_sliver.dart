import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

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
          final message = messages[index];

          return message.isSent
              ? SentMessageArea(
                  message: message,
                )
              : ReceivedMessageArea(
                  message: message,
                );
        },
        childCount: messages.length,
      ),
    );
  }
}
