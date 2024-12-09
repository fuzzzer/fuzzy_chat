import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

export 'widgets/widgets.dart';

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

    _chatNameController.addListener(() {
      setState(() {});
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
        SnackBar(
          content: Text(
            FuzzyChatLocalizations.of(context)?.pleaseEnterAChatName ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return BlocConsumer<ChatCreationCubit, ChatCreationState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.generatedChatInvitation != null) {
          Navigator.of(context).pushReplacement(
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
            SnackBar(
              content: Text(
                state.failure?.message ?? localizations.failedToCreateChat,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return StatusBuilder.buildByStatus(
          status: state.status,
          onInitial: () => ChatCreationInitialContent(
            chatNameController: _chatNameController,
            focusNode: _focusNode,
            onCreate: _createChat,
          ),
          onLoading: () => const FuzzyLoadingPagebuilder(),
          onSuccess: () => ChatCreationInitialContent(
            chatNameController: _chatNameController,
            focusNode: _focusNode,
            onCreate: _createChat,
          ),
          onFailure: () => FuzzyErrorPageBuilder(
            message: state.failure?.message ?? localizations.failedToCreateChat,
          ),
        );
      },
    );
  }
}
