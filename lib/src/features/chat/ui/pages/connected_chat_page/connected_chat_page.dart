import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';

export 'components/components.dart';
export 'widgets/widgets.dart';

class ConnectedChatPage extends StatelessWidget {
  final ConnectedChatPagePayload payload;

  const ConnectedChatPage({
    required this.payload,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectedChatCubit>(
      create: (context) => ConnectedChatCubit(
        chatId: payload.chatId,
        messageDataRepository: sl.get<MessageDataRepository>(),
        keyStorageRepository: sl.get<KeyStorageRepository>(),
      )..loadMessages(),
      child: ProvidedConnectedChatPage(payload: payload),
    );
  }
}

class ProvidedConnectedChatPage extends StatefulWidget {
  final ConnectedChatPagePayload payload;

  const ProvidedConnectedChatPage({
    required this.payload,
    super.key,
  });

  @override
  State<ProvidedConnectedChatPage> createState() => _ProvidedConnectedChatPageState();
}

class _ProvidedConnectedChatPageState extends State<ProvidedConnectedChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ConnectedChatCubit>().sendMessage(text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _receiveMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ConnectedChatCubit>().receiveMessage(text);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void openSettingsToolbox() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ConnectedChatCubit, ConnectedChatState>(
        builder: (context, state) {
          return Stack(
            children: [
              CustomScrollView(
                reverse: true,
                controller: _scrollController,
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 300),
                  ),
                  MessageListSliver(
                    messages: state.messages,
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
                  onEncryptTap: _sendMessage,
                  onDecryptTap: _receiveMessage,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
