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
    FuzzzyToast.show(
      context,
      message: localizations.acceptanceCopiedToClipboard,
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
    FuzzzyToast.show(
      context,
      message: localizations.linkCopiedToClipboard,
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
              FuzzzyAppBar(
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
              FuzzzyButton(
                label: localizations.copyAcceptance,
                icon: const Icon(Icons.copy),
                onPressed: () => _copyAcceptance(context),
              ),
              const SizedBox(height: 12),
              FuzzzyButton(
                label: localizations.shareAcceptance,
                icon: const Icon(Icons.share),
                onPressed: () =>
                    ShareHelper.share(acceptanceContent, context: context),
              ),
              const SizedBox(height: 12),
              FuzzzyButton(
                label: localizations.shareAsLink,
                icon: const Icon(Icons.share),
                onPressed: () => _shareAsLink(context),
              ),
              const SizedBox(height: 12),
              FuzzzyButton(
                label: localizations.copyAsLink,
                icon: const Icon(Icons.link),
                onPressed: () => _copyAsLink(context),
              ),
              const Spacer(),
              if (hasBackButton)
                const FuzzyBackButton()
              else
                FuzzzyButton(
                  label: localizations.goToChat,
                  onPressed: () {
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
