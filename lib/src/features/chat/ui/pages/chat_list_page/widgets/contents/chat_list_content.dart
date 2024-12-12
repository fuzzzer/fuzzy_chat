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
    final localizations = FuzzyChatLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FuzzyHeader(
            title: localizations.fuzzyChat,
          ),
        ),
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
