import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

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
                          context.push(
                            AppRouter.chatInvitation,
                            extra: ChatInvitationPagePayload(
                              chatName: chatGeneralData.chatName,
                              chatId: chatGeneralData.chatId,
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
                          context.push(
                            AppRouter.chatConnected,
                            extra: ConnectedChatPagePayload(
                              chatGeneralData: chatGeneralData,
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
