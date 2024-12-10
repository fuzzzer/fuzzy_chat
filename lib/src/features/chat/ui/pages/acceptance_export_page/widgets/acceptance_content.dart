import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';

class AcceptanceContent extends StatelessWidget {
  final String acceptanceContent;
  final bool hasBackButton;
  final ChatGeneralData chatGeneralData;

  const AcceptanceContent({
    super.key,
    required this.acceptanceContent,
    required this.hasBackButton,
    required this.chatGeneralData,
  });

  void _copyAcceptance(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    Clipboard.setData(ClipboardData(text: acceptanceContent));
    ScaffoldMessenger.of(context).showSnackBar(
      FuzzySnackBar(
        label: localizations.acceptanceCopiedToClipboard,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = FuzzyChatLocalizations.of(context)!;

    return FuzzyScaffold(
      hasAutomaticBackButton: false,
      body: Padding(
        padding: const EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: 16,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              FuzzyHeader(
                title: localizations.exportAcceptance,
              ),
              const Spacer(),
              Text(
                localizations.yourAcceptanceHasBeenGeneratedSuccessfully,
                textAlign: TextAlign.center,
                style: uiTextStyles.body16,
              ),
              const SizedBox(height: 16),
              FuzzyButton(
                text: localizations.copyAcceptance,
                icon: Icons.copy,
                onTap: () => _copyAcceptance(context),
              ),
              const Spacer(),
              if (hasBackButton)
                const FuzzyBackButton()
              else
                FuzzyButton(
                  text: localizations.goToChat,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ConnectedChatPage(
                          payload: ConnectedChatPagePayload(
                            chatGeneralData: chatGeneralData,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
