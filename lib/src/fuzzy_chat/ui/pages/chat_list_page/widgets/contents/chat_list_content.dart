import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class ChatListContent extends StatelessWidget {
  final List<ChatGeneralData> chatGeneralDataList;

  const ChatListContent({
    super.key,
    required this.chatGeneralDataList,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.fuzzyChatLocalizations;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FuzzyHeader(
            title: localizations.fuzzyChat,
            //(NOTE:) enable copy own raw messages if needed
            // leftAction: GestureDetector(
            //   onTap: () => Navigator.of(context).push(
            //     MaterialPageRoute(builder: (_) => const SettingsPage()),
            //   ),
            //   child: Icon(
            //     Icons.settings_outlined,
            //     size: 22,
            //     color: context.uiColors.secondaryTextColor,
            //   ),
            // ),
            rightAction: const BasicEncryptionNavigatorAction(),
          ),
        ),
        if (chatGeneralDataList.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: context.uiColors.secondaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations.noOngoingChats,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.uiColors.primaryTextColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.tapTheButtonBelowToCreateANewSecureHandshakeOrAcceptAnInvitation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.uiColors.secondaryTextColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80), // To avoid FAB overlapping
                ],
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final chatGeneralData = chatGeneralDataList[index];
                return chatGeneralData.setupStatus == ChatSetupStatus.invited
                    ? InvitedChatTile(
                        name: chatGeneralData.chatName,
                        onLongPress: () {
                          showChatDeletionDialog(
                            context,
                            chatId: chatGeneralData.chatId,
                            chatName: chatGeneralData.chatName,
                          );
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatInvitationPage(
                                payload: ChatInvitationPagePayload(
                                  chatName: chatGeneralData.chatName,
                                  chatId: chatGeneralData.chatId,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ConnectedChatTile(
                        name: chatGeneralData.chatName,
                        onLongPress: () {
                          showChatDeletionDialog(
                            context,
                            chatId: chatGeneralData.chatId,
                            chatName: chatGeneralData.chatName,
                          );
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ConnectedChatPage(
                                payload: ConnectedChatPagePayload(
                                  chatGeneralData: chatGeneralData,
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
              childCount: chatGeneralDataList.length,
            ),
          ),
      ],
    );
  }
}
