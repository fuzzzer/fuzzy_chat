import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/features/chat/ui/pages/connected_chat_page/connected_chat_page.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

class AcceptanceExportPage extends StatelessWidget {
  const AcceptanceExportPage({super.key});

  void _downloadAcceptance() {}

  void _shareAcceptance() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'Acceptance Ready',
                style: uiTextStyles.bodyLargeBold20,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                'Your acceptance has been generated successfully.',
                textAlign: TextAlign.center,
                style: uiTextStyles.bodyBold16,
              ),
              const SizedBox(height: 16),
              FuzzyButton(
                text: 'Download Acceptance',
                icon: Icons.download,
                onPressed: _downloadAcceptance,
              ),
              const SizedBox(height: 16),
              FuzzyButton(
                text: 'Share Acceptance',
                icon: Icons.share,
                onPressed: _shareAcceptance,
              ),
              const Spacer(),
              FuzzyButton(
                text: 'Go to chat',
                //TODO before navigating store everything necessary fot the chat
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ConnectedChatPage(
                      payload: ConnectedChatPagePayload(
                        chatName: 'think of when to name the chat',
                        chatId: 'chatId',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
