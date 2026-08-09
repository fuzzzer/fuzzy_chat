import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';
import 'package:go_router/go_router.dart';

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
    final localizations = context.fuzzyChatLocalizations;

    Clipboard.setData(ClipboardData(text: acceptanceContent));
    FuzzySnackbar.show(
      label: localizations.acceptanceCopiedToClipboard,
    );
  }

  void _shareAsLink(BuildContext context) {
    final link = FuzzyLinkGenerator.generateAcceptanceLink(acceptanceContent);
    final shareable = FuzzyLinkGenerator.generateShareableContent(
      link: link,
      rawFuzz: acceptanceContent,
      type: FuzzyLinkType.acceptance,
    );
    ShareHelper.share(shareable, context: context);
  }

  void _copyAsLink(BuildContext context) {
    final localizations = context.fuzzyChatLocalizations;
    final link = FuzzyLinkGenerator.generateAcceptanceLink(acceptanceContent);
    Clipboard.setData(ClipboardData(text: link));
    FuzzySnackbar.show(
      label: localizations.linkCopiedToClipboard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fuzzzyTextStyles = context.fuzzzyTextStyles;

    final localizations = context.fuzzyChatLocalizations;

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
                style: fuzzzyTextStyles.body.copyWith(
                  color: context.fuzzzyColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              FuzzyButton(
                text: localizations.copyAcceptance,
                icon: Icons.copy,
                onTap: () => _copyAcceptance(context),
              ),
              const SizedBox(height: 12),
              FuzzyButton(
                text: localizations.shareAcceptance,
                icon: Icons.share,
                onTap: () =>
                    ShareHelper.share(acceptanceContent, context: context),
              ),
              const SizedBox(height: 12),
              FuzzyButton(
                text: localizations.shareAsLink,
                icon: Icons.share,
                onTap: () => _shareAsLink(context),
              ),
              const SizedBox(height: 12),
              FuzzyButton(
                text: localizations.copyAsLink,
                icon: Icons.link,
                onTap: () => _copyAsLink(context),
              ),
              const Spacer(),
              if (hasBackButton)
                const FuzzyBackButton()
              else
                FuzzyButton(
                  text: localizations.goToChat,
                  onTap: () {
                    context.go(
                      AppRouter.chatConnected,
                      extra: ConnectedChatPagePayload(
                        chatGeneralData: chatGeneralData,
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
