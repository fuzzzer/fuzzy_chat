import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

export 'components/components.dart';
export 'widgets/widgets.dart';

class InvitationAcceptancePage extends StatelessWidget {
  const InvitationAcceptancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvitationAcceptanceCubit>(
      create: (context) => InvitationAcceptanceCubit(
        chatGeneralDataListRepository: sl.get<ChatGeneralDataListRepository>(),
        keyStorageRepository: sl.get<KeyStorageRepository>(),
      ),
      child: const ProvidedInvitationAcceptancePage(),
    );
  }
}

class ProvidedInvitationAcceptancePage extends StatefulWidget {
  const ProvidedInvitationAcceptancePage({super.key});

  @override
  State<ProvidedInvitationAcceptancePage> createState() => _ProvidedInvitationAcceptancePageState();
}

class _ProvidedInvitationAcceptancePageState extends State<ProvidedInvitationAcceptancePage> {
  final TextEditingController _invitationTextController = TextEditingController();
  final TextEditingController _chatNameController = TextEditingController();

  @override
  void initState() {
    _invitationTextController.addListener(() {
      setState(() {});
    });

    _chatNameController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _invitationTextController.dispose();
    _chatNameController.dispose();
    super.dispose();
  }

  void _acceptInvitation() {
    final invitationText = _invitationTextController.text.trim();
    final chatName = _chatNameController.text.trim();
    if (invitationText.isNotEmpty && chatName.isNotEmpty) {
      context.read<InvitationAcceptanceCubit>().acceptInvitation(
            invitationContent: invitationText,
            chatName: chatName,
          );
    } else {
      FuzzySnackbar.show(
        label: FuzzyChatLocalizations.of(context)?.pleaseProvideInvitationTextAndChatName ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.fuzzyChatLocalizations;

    return BlocConsumer<InvitationAcceptanceCubit, InvitationAcceptanceState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.generatedAcceptance != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AcceptanceExportPage(
                payload: AcceptanceExportPagePayload(
                  chatGeneralData: state.chatData!,
                  hasBackButton: false,
                ),
              ),
            ),
          );
        } else if (state.status.isFailed) {
          FuzzySnackbar.show(
            label: state.failure?.type.toUiMessage(
              localizations,
              customUnknownMessage: FuzzyChatLocalizations.of(context)?.failedToAcceptInvitation,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status.isLoading) {
          return const FuzzyLoadingPagebuilder();
        }

        return InvitationAcceptanceForm(
          chatNameController: _chatNameController,
          invitationTextController: _invitationTextController,
          onAccept: _acceptInvitation,
        );
      },
    );
  }
}
