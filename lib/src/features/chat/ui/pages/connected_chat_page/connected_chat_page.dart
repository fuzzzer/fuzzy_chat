import 'package:flutter/material.dart';

import '../../../chat.dart';
import 'components/components.dart';
import 'widgets/widgets.dart';

export 'components/components.dart';
export 'widgets/widgets.dart';

class ConnectedChatPage extends StatefulWidget {
  final ConnectedChatPagePayload payload;

  const ConnectedChatPage({
    required this.payload,
    super.key,
  });

  @override
  State<ConnectedChatPage> createState() => _ConnectedChatPageState();
}

class _ConnectedChatPageState extends State<ConnectedChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<MessageData> messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  //TODO Do this with bloc when logic is introduced
  void _sendMessage({
    required bool isSent,
  }) {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(
          MessageData(
            chatId: widget.payload.chatId,
            fuzzyMessage: _messageController.text,
            sentAt: DateTime.now(),
            isSent: isSent,
          ),
        );
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void openSettingsToolbox() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            reverse: true,
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 300),
              ),
              MessageListSliver(
                messages: messages,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ChatHeader(
              chatName: widget.payload.chatName,
              onBackPressed: () => Navigator.pop(context),
              onSettingsPressed: openSettingsToolbox,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MessageInputField(
              controller: _messageController,
              focusNode: _messageFocusNode,
              onEncryptTap: () {
                _sendMessage(
                  isSent: true,
                );
              },
              onDecryptTap: () {
                _sendMessage(
                  isSent: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
