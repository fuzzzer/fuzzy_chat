import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

export 'components/components.dart';

class ChatInvitationPage extends StatelessWidget {
  final ChatInvitationPagePayload payload;

  const ChatInvitationPage({
    super.key,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InvitationReaderCubit>(
          create: (context) => InvitationReaderCubit(
            handshakeManager: sl.get<HandshakeManager>(),
            keyStorageRepository: sl.get<KeyStorageRepository>(),
          )..generateInvitation(payload.chatId),
        ),
        BlocProvider<HandshakeCubit>(
          create: (context) => HandshakeCubit(
            handshakeManager: sl.get<HandshakeManager>(),
            keyStorageRepository: sl.get<KeyStorageRepository>(),
            chatGeneralDataListRepository: sl.get<ChatGeneralDataListRepository>(),
          ),
        ),
      ],
      child: ProvidedChatInvitationPage(
        payload: payload,
      ),
    );
  }
}

class ProvidedChatInvitationPage extends StatefulWidget {
  final ChatInvitationPagePayload payload;

  const ProvidedChatInvitationPage({
    required this.payload,
    super.key,
  });

  @override
  State<ProvidedChatInvitationPage> createState() => _ProvidedChatInvitationPageState();
}

class _ProvidedChatInvitationPageState extends State<ProvidedChatInvitationPage> {
  final TextEditingController acceptanceTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InvitationReaderCubit>().generateInvitation(widget.payload.chatId);
  }

  void _importAcceptanceFromText() {
    final acceptanceContent = acceptanceTextController.text.trim();
    if (acceptanceContent.isNotEmpty) {
      context.read<HandshakeCubit>().completeHandshake(
            acceptanceContent: acceptanceContent,
            chatId: widget.payload.chatId,
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste the acceptance content.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HandshakeCubit, HandshakeState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ConnectedChatPage(
                    payload: ConnectedChatPagePayload(
                      chatName: widget.payload.chatName,
                      chatId: widget.payload.chatId,
                    ),
                  ),
                ),
              );
            } else if (state.status.isFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.failure?.message ?? 'Failed to complete handshake')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<InvitationReaderCubit, InvitationReaderState>(
          builder: (context, invitationState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: StatusBuilder.buildByStatus(
                status: invitationState.status,
                onInitial: _buildLoadingContent,
                onLoading: _buildLoadingContent,
                onSuccess: () => _buildInvitationContent(invitationState),
                onFailure: () => _buildErrorContent(invitationState.failure?.message),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildInvitationContent(InvitationReaderState invitationState) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FuzzyHeader(
            title: widget.payload.chatName,
          ),
          const SizedBox(height: 16),
          const Text(
            'Send Invitation',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FuzzyButton(
            text: 'Copy Invitation',
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: invitationState.invitation!.invitationContent),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitation copied to clipboard')),
              );
            },
            icon: Icons.copy,
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Provide Acceptance',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FuzzyTextField(
            labelText: 'Paste Acceptance Text',
            controller: acceptanceTextController,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          FuzzyButton(
            text: 'Accept',
            onPressed: _importAcceptanceFromText,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(String? message) {
    return Center(
      child: Text(
        message ?? 'Failed to generate invitation.',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
