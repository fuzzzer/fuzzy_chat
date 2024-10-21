import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/candy_tools/candy_tools.dart';
import 'package:fuzzy_chat/src/core/services/services.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/ui_kit/ui_kit.dart';

export 'widgets/widgets.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatGeneralDataListCubit>(
      create: (context) => ChatGeneralDataListCubit(
        chatRepository: sl.get<ChatGeneralDataListRepository>(),
      )..fetchChats(),
      child: const ProvidedChatListPage(),
    );
  }
}

class ProvidedChatListPage extends StatefulWidget {
  const ProvidedChatListPage({super.key});

  @override
  State<ProvidedChatListPage> createState() => _ProvidedChatListPageState();
}

class _ProvidedChatListPageState extends State<ProvidedChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatGeneralDataListCubit, ChatGeneralDataListState>(
        builder: (context, state) {
          return StatusBuilder.buildByStatus(
            status: state.status,
            onInitial: () => const Center(child: CircularProgressIndicator()),
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onSuccess: () => _buildChatList(state.chats!),
            onFailure: () => _buildErrorContent(state.failure?.message),
          );
        },
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

  Widget _buildChatList(List<ChatGeneralData> chats) {
    return CustomScrollView(
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
    );
  }

  Widget _buildErrorContent(String? message) {
    return Center(
      child: Text(
        message ?? 'Failed to load chats.',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
