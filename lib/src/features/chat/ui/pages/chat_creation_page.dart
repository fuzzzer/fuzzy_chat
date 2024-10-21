import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

class ChatCreationPage extends StatelessWidget {
  const ChatCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCreationCubit>(
      create: (context) => ChatCreationCubit(
        handshakeManager: sl.get<HandshakeManager>(),
        keyStorageRepository: sl.get<KeyStorageRepository>(),
        chatGeneralDataListRepository: sl.get<ChatGeneralDataListRepository>(),
      ),
      child: const ProvidedChatCreationPage(),
    );
  }
}

class ProvidedChatCreationPage extends StatefulWidget {
  const ProvidedChatCreationPage({super.key});

  @override
  State<ProvidedChatCreationPage> createState() => _ProvidedChatCreationPageState();
}

class _ProvidedChatCreationPageState extends State<ProvidedChatCreationPage> {
  final TextEditingController _chatNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _chatNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _createChat() {
    final chatName = _chatNameController.text.trim();
    if (chatName.isNotEmpty) {
      context.read<ChatCreationCubit>().createChat(chatName: chatName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a chat name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCreationCubit, ChatCreationState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.generatedChatInvitation != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatInvitationPage(
                payload: ChatInvitationPagePayload(
                  chatName: state.chatName!,
                  chatId: state.chatId!,
                ),
              ),
            ),
          );
        } else if (state.status.isFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure?.message ?? 'Failed to create chat')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: StatusBuilder.buildByStatus(
              status: state.status,
              onInitial: _buildInitialContent,
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onSuccess: _buildInitialContent,
              onFailure: () => _buildErrorContent(state.failure?.message),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitialContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const FuzzyHeader(title: 'Create a New Chat'),
        FuzzyTextField(
          controller: _chatNameController,
          focusNode: _focusNode,
          labelText: 'Enter Chat Name',
          hintText: 'e.g. Chat with Alice',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FuzzyButton(
              text: 'Back',
              onPressed: () => Navigator.pop(context),
            ),
            FuzzyButton(
              text: 'Create',
              onPressed: _createChat,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorContent(String? message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message ?? 'Failed to create chat',
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 16),
        FuzzyButton(
          text: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
