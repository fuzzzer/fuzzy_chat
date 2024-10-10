import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import 'components/components.dart';

export 'components/components.dart';

class ChatInvitationPage extends StatefulWidget {
  final ChatInvitationPagePayload payload;

  const ChatInvitationPage({
    required this.payload,
    super.key,
  });

  @override
  State<ChatInvitationPage> createState() => _ChatInvitationPageState();
}

class _ChatInvitationPageState extends State<ChatInvitationPage> {
  final acceptanceTextController = TextEditingController();

  void _downloadInvitation() {}

  void _shareInvitation() {}

  //TODO navigator to connected chat page when acceptance is provided
  void _importAcceptanceFromText() {}

  void _importAcceptanceFromFile() {}

  // TODO: Use bloc instead
  final bool isGeneratingKeys = false;

  @override
  void dispose() {
    acceptanceTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top part with the header
              FuzzyHeader(
                title: widget.payload.chatName,
              ),
              const SizedBox(height: 16),
              if (isGeneratingKeys)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Generating Keys...',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      'Send Invitation',
                      textAlign: TextAlign.center,
                      style: uiTextStyles.bodyBold16,
                    ),
                    const SizedBox(height: 20),
                    FuzzyButton(
                      text: 'Download Invitation',
                      onPressed: _downloadInvitation,
                      icon: Icons.download,
                    ),
                    const SizedBox(height: 16),
                    FuzzyButton(
                      text: 'Share Invitation',
                      onPressed: _shareInvitation,
                      icon: Icons.share,
                    ),
                  ],
                ),
              const SizedBox(height: 150),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Provide Acceptance',
                textAlign: TextAlign.center,
                style: uiTextStyles.bodyBold16,
              ),
              const SizedBox(height: 100),
              FuzzyTextField(
                labelText: 'Paste Base64 Acceptance',
                controller: acceptanceTextController,
                scrollPadding: const EdgeInsets.only(bottom: 120),
              ),
              const SizedBox(height: 16),
              FuzzyButton(
                text: 'Accept',
                onPressed: _importAcceptanceFromText,
              ),
              const SizedBox(height: 56),
              FuzzyButton(
                text: 'Import Acceptance',
                onPressed: _importAcceptanceFromFile,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
