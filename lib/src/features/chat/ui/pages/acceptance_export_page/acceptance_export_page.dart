import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

export 'components/components.dart';

class AcceptanceExportPage extends StatelessWidget {
  final AcceptanceExportPagePayload payload;

  const AcceptanceExportPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AcceptanceReaderCubit>(
      create: (context) => AcceptanceReaderCubit(
        handshakeManager: sl.get<HandshakeManager>(),
        keyStorageRepository: sl.get<KeyStorageRepository>(),
      )..generateAcceptance(chatId: payload.chatGeneralData.chatId),
      child: ProvidedAcceptanceExportPage(payload: payload),
    );
  }
}

class ProvidedAcceptanceExportPage extends StatelessWidget {
  final AcceptanceExportPagePayload payload;

  const ProvidedAcceptanceExportPage({super.key, required this.payload});

  void _copyAcceptance(String acceptanceContent, BuildContext context) {
    Clipboard.setData(ClipboardData(text: acceptanceContent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Acceptance copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AcceptanceReaderCubit, AcceptanceReaderState>(
        builder: (context, state) {
          return StatusBuilder.buildByStatus(
            status: state.status,
            onInitial: () => const Center(child: CircularProgressIndicator()),
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onSuccess: () => _buildAcceptanceContent(context, state.acceptance!.acceptanceContent),
            onFailure: () => _buildErrorContent(state.failure?.message),
          );
        },
      ),
    );
  }

  Widget _buildAcceptanceContent(
    BuildContext context,
    String acceptanceContent,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Acceptance Ready',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            const Text(
              'Your acceptance has been generated successfully.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FuzzyButton(
              text: 'Copy Acceptance',
              icon: Icons.copy,
              onPressed: () => _copyAcceptance(acceptanceContent, context),
            ),
            const Spacer(),
            if (payload.hasBackButton)
              FuzzyButton(
                text: 'Back',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            else
              FuzzyButton(
                text: 'Go to chat',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ConnectedChatPage(
                        payload: ConnectedChatPagePayload(
                          chatGeneralData: payload.chatGeneralData,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(String? message) {
    return Center(
      child: Text(
        message ?? 'Failed to generate acceptance.',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
