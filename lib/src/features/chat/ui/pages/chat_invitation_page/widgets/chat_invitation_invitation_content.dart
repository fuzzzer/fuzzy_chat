import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';

class ChatInvitationInvitationContent extends StatefulWidget {
  final String chatName;
  final String invitationContent;
  final TextEditingController acceptanceTextController;
  final VoidCallback onAccept;

  const ChatInvitationInvitationContent({
    super.key,
    required this.chatName,
    required this.invitationContent,
    required this.acceptanceTextController,
    required this.onAccept,
  });

  @override
  State<ChatInvitationInvitationContent> createState() => _ChatInvitationInvitationContentState();
}

class _ChatInvitationInvitationContentState extends State<ChatInvitationInvitationContent> {
  final deboucer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    deboucer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;

    final localizations = FuzzyChatLocalizations.of(context)!;

    return FuzzyScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FuzzyHeader(
                title: widget.chatName,
              ),
              const SizedBox(height: 48),
              Text(
                localizations
                    .inOrderToStartFuzzyChatWithSomeoneFirstTheyNeedToImportTheInvitationAndProvideAcceptanceFileOrTextGeneratedOnTheirChatSoTheyCanAlsoSendAndUnlockMessages,
                textAlign: TextAlign.center,
                style: uiTextStyles.body16,
              ),
              const SizedBox(height: 20),
              FuzzyButton(
                text: localizations.copyInvitation,
                icon: Icons.copy,
                onTap: () {
                  deboucer.run(() {
                    Clipboard.setData(
                      ClipboardData(text: widget.invitationContent),
                    ).then((_) {
                      scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text(
                            localizations.invitationCopiedToClipboard,
                          ),
                        ),
                      );
                    });
                  });
                },
              ),
              const SizedBox(height: 48),
              Divider(
                height: 20,
                thickness: 4,
                color: uiColors.secondaryColor,
              ),
              const SizedBox(height: 48),
              Text(
                localizations.theAcceptanceThatYouGetFromInvitedPersonShouldBePastedHere,
                textAlign: TextAlign.center,
                style: uiTextStyles.body16,
              ),
              const SizedBox(height: 16),
              FuzzyTextField(
                labelText: localizations.pasteAcceptanceText,
                controller: widget.acceptanceTextController,
                maxLines: 3,
                scrollPadding: const EdgeInsets.only(bottom: 150),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      actionsRow: FuzzyActionsRow(
        isMainActionEnabled: widget.acceptanceTextController.text.isNotEmpty,
        mainActionLabel: localizations.accept,
        onMainActionPressed: widget.onAccept,
      ),
    );
  }
}
