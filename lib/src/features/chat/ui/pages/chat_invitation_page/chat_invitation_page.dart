import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

export 'components/components.dart';
export 'widgets/widgets.dart';

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
          )..generateInvitation(
              chatId: payload.chatId,
            ),
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
    context.read<InvitationReaderCubit>().generateInvitation(
          chatId: widget.payload.chatId,
        );

    acceptanceTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    acceptanceTextController.dispose();
    super.dispose();
  }

  void _importAcceptanceFromText() {
    final acceptanceContent = acceptanceTextController.text.trim();
    if (acceptanceContent.isNotEmpty) {
      context.read<HandshakeCubit>().completeHandshake(
            acceptanceContent: acceptanceContent,
            chatId: widget.payload.chatId,
          );
    } else {
      FuzzySnackbar.show(
        label: FuzzyChatLocalizations.of(context)?.pleasePasteTheAcceptanceContent ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<HandshakeCubit, HandshakeState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ConnectedChatPage(
                    payload: ConnectedChatPagePayload(
                      chatGeneralData: state.chatData!,
                    ),
                  ),
                ),
              );
            } else if (state.status.isFailed) {
              FuzzySnackbar.show(
                label: state.failure?.message ?? localizations.failedToCompleteHandshake,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<InvitationReaderCubit, InvitationReaderState>(
        builder: (context, invitationState) {
          return StatusBuilder.buildByStatus(
            status: invitationState.status,
            onInitial: () => const FuzzyLoadingPagebuilder(),
            onLoading: () => const FuzzyLoadingPagebuilder(),
            onSuccess: () => ChatInvitationContent(
              chatName: widget.payload.chatName,
              invitationContent: invitationState.invitation!.invitationContent,
              acceptanceTextController: acceptanceTextController,
              onAccept: _importAcceptanceFromText,
            ),
            onFailure: () => FuzzyErrorPageBuilder(
              message: invitationState.failure?.message ?? localizations.failedToGenerateInvitation,
            ),
          );
        },
      ),
    );
  }
}
