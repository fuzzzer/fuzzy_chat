import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

class InvitationAcceptancePage extends StatelessWidget {
  const InvitationAcceptancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvitationAcceptanceCubit>(
      create: (context) => InvitationAcceptanceCubit(
        handshakeManager: sl.get<HandshakeManager>(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide invitation text and chat name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvitationAcceptanceCubit, InvitationAcceptanceState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.generatedAcceptance != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AcceptanceExportPage(
                payload: AcceptanceExportPagePayload(
                  chatName: state.chatName!,
                  chatId: state.chatId!,
                ),
              ),
            ),
          );
        } else if (state.status.isFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure?.message ?? 'Failed to accept invitation')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: StatusBuilder.buildByStatus(
              status: state.status,
              onInitial: _buildAcceptanceForm,
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onSuccess: _buildAcceptanceForm,
              onFailure: () => _buildErrorContent(state.failure?.message),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAcceptanceForm() {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Accept Chat Invitation',
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        FuzzyTextField(
          controller: _chatNameController,
          labelText: 'Enter Chat Name',
        ),
        const SizedBox(height: 16),
        FuzzyTextField(
          controller: _invitationTextController,
          labelText: 'Paste Invitation Text',
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        FuzzyButton(
          text: 'Accept Invitation',
          onPressed: _acceptInvitation,
        ),
        const Spacer(),
        FuzzyButton(
          text: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildErrorContent(String? message) {
    return Column(
      children: [
        Text(
          message ?? 'Failed to accept invitation',
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 16),
        _buildAcceptanceForm(),
      ],
    );
  }
}
