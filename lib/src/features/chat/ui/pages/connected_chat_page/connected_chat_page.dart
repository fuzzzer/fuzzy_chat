import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

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
        chatId: payload.chatGeneralData.chatId,
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

  bool isEncrypting = true;

  @override
  void initState() {
    _messageController.addListener(_onMessageUpdated);
    super.initState();
  }

  void _onMessageUpdated() {
    setState(() {
      isEncrypting = !_messageController.text.startsWith(fuzzIdentificator);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final isFuzzed = text.startsWith(fuzzIdentificator);

    if (isFuzzed) {
      _receiveMessage(text.substring(5));
    } else {
      _sendMessage(text);
    }
  }

  void _sendMessage(String text) {
    context.read<ConnectedChatCubit>().sendMessage(text: text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _receiveMessage(String text) {
    context.read<ConnectedChatCubit>().receiveMessage(encryptedText: text);
    _messageController.clear();
    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    return FuzzyScaffold(
      hasAutomaticBackButton: false,
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
                  chatGeneralData: widget.payload.chatGeneralData,
                  onBackPressed: () => Navigator.pop(context),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MessageInputField(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  onSend: _onSend,
                  isEncrypting: isEncrypting,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
