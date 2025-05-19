import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

export 'widgets/widgets.dart';

class ChatCreationPage extends StatelessWidget {
  const ChatCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCreationCubit>(
      create: (context) => ChatCreationCubit(
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
      FuzzySnackbar.show(
        label: FuzzyChatLocalizations.of(context)?.pleaseEnterAChatName ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.fuzzyChatLocalizations;

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
          FuzzySnackbar.show(
            label: state.failure?.type.toUiMessage(localizations),
          );
        }
      },
      builder: (context, state) {
        if (state.status.isLoading) {
          return const FuzzyLoadingPagebuilder();
        }

        return ChatCreationInitialContent(
          chatNameController: _chatNameController,
          focusNode: _focusNode,
          onCreate: _createChat,
        );
      },
    );
  }
}
