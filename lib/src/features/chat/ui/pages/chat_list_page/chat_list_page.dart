import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

export 'widgets/widgets.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProvidedChatListPage();
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
    final localizations = FuzzyChatLocalizations.of(context)!;

    return FuzzyScaffold(
      hasAutomaticBackButton: false,
      body: BlocBuilder<ChatGeneralDataListCubit, ChatGeneralDataListState>(
        builder: (context, state) {
          return StatusBuilder.buildByStatus(
            status: state.status,
            onInitial: () => const FuzzyLoadingPagebuilder(),
            onLoading: () => const FuzzyLoadingPagebuilder(),
            onSuccess: () => ChatListContent(
              chatGeneralDataList: state.chatList!,
            ),
            onFailure: () => FuzzyErrorPageBuilder(
              hasAutomaticBackButton: false,
              message: state.failure?.message ?? localizations.failedToLoadChats,
            ),
          );
        },
      ),
      actionsRow: Align(
        alignment: Alignment.bottomRight,
        child: FloatingToolbox(
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
      ),
    );
  }
}
