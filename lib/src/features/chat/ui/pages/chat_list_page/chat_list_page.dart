import 'package:flutter/material.dart';
import 'package:fuzzy_chat/src/features/chat/ui/pages/connected_chat_page/connected_chat_page.dart';
import 'package:fuzzy_chat/src/features/chat/ui/ui.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

import '../../../data/data.dart';

export 'widgets/widgets.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          const SliverToBoxAdapter(
            child: Center(
              child: FuzzyHeader(
                title: 'Fuzzy Chat',
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final chat = chats[index];
                switch (chat.setupStatus) {
                  case ChatSetupStatus.invited:
                    return InvitedChatTile(
                      name: chat.chatName,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatInvitationPage(
                              payload: ChatInvitationPagePayload(
                                chatName: chat.chatName,
                                chatId: chat.chatId,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  case ChatSetupStatus.connected:
                    return ConnectedChatTile(
                      name: chat.chatName,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ConnectedChatPage(
                              payload: ConnectedChatPagePayload(
                                chatName: chat.chatName,
                                chatId: chat.chatId,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                }
              },
              childCount: chats.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingToolbox(
        onNewChatPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ChatCreationPage(),
            ),
          );
        },
        onAcceptInvitationPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const InvitationAcceptancePage(),
            ),
          );
        },
      ),
    );
  }
}

final List<ChatGeneralData> chats = [
  ChatGeneralData(
    chatId: 'someId',
    chatName: 'Invited Bob',
    setupStatus: ChatSetupStatus.invited,
  ),
  ChatGeneralData(
    chatId: 'someId',
    chatName: 'Jonny',
    setupStatus: ChatSetupStatus.connected,
  ),
  ChatGeneralData(
    chatId: 'someId',
    chatName: 'Xan',
    setupStatus: ChatSetupStatus.connected,
  ),
  ChatGeneralData(
    chatId: 'someId',
    chatName: 'Invited Alice',
    setupStatus: ChatSetupStatus.invited,
  ),
];
