import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:go_router/go_router.dart';

export 'components/components.dart';
export 'widgets/widgets.dart';

class ConnectedChatPage extends StatelessWidget {
  final ConnectedChatPagePayload payload;

  const ConnectedChatPage({
    required this.payload,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectedChatCubit>(
      create: (context) => ConnectedChatCubit(
        chatId: payload.chatGeneralData.chatId,
        messageDataRepository: sl.get<MessageDataRepository>(),
        keyStorageRepository: sl.get<KeyStorageRepository>(),
      )..loadInitialMessages(),
      child: ProvidedConnectedChatPage(payload: payload),
    );
  }
}

class ProvidedConnectedChatPage extends StatefulWidget {
  final ConnectedChatPagePayload payload;

  const ProvidedConnectedChatPage({
    required this.payload,
    super.key,
  });

  @override
  State<ProvidedConnectedChatPage> createState() => _ProvidedConnectedChatPageState();
}

class _ProvidedConnectedChatPageState extends State<ProvidedConnectedChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<String>? selectedFilePaths;

  bool isEncrypting = true;
  late bool _showTutorial;

  @override
  void initState() {
    _showTutorial = !sl.get<PreferencesService>().hasCompletedTutorial;
    _messageController.addListener(_onMessageUpdated);
    initializePagination();
    super.initState();

    // Pre-fill encrypted message from deep link.
    if (widget.payload.prefillEncryptedMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _messageController.text = '$fuzzIdentificator${widget.payload.prefillEncryptedMessage}';
      });
    }
  }

  void _onMessageUpdated() {
    setState(() {
      isEncrypting = !_messageController.text.startsWith(fuzzIdentificator);
    });
  }

  void initializePagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 20) {
        loadOlderMessages();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void loadOlderMessages() {
    final connectedChatCubit = context.read<ConnectedChatCubit>();

    if (connectedChatCubit.state.status.isLoading) return;
    if (connectedChatCubit.state.status.isFailed) {
      connectedChatCubit.loadCurrentMessagesPage();
      return;
    }

    connectedChatCubit.loadOlderMessages();
  }

  void _onSend() {
    _sendText();
    _sendFiles();
  }

  void _sendFiles() {
    final fileEncryptionCubit = context.read<FileProcessingCubit<FileEncryptionOption>>();
    final fileDecryptionCubit = context.read<FileProcessingCubit<FileDecryptionOption>>();

    if (selectedFilePaths?.isNotEmpty == true) {
      for (final filePath in selectedFilePaths!) {
        if (filePath.endsWith(fuzzedFileIdentificator)) {
          fileDecryptionCubit.addFilesToProcess(
            chatName: widget.payload.chatGeneralData.chatName,
            chatId: widget.payload.chatGeneralData.chatId,
            filePaths: [filePath],
          );
        } else {
          fileEncryptionCubit.addFilesToProcess(
            chatName: widget.payload.chatGeneralData.chatName,
            chatId: widget.payload.chatGeneralData.chatId,
            filePaths: [filePath],
          );
        }
      }
    }

    setState(() {
      selectedFilePaths = null;
    });
  }

  void _sendText() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_showTutorial && mounted) {
      sl.get<PreferencesService>().setHasCompletedTutorial(true);
      setState(() {
        _showTutorial = false;
      });
    }

    final isFuzzed = text.startsWith(fuzzIdentificator);

    if (isFuzzed) {
      _receiveMessage(text.substring(5));
    } else {
      _sendMessage(text);
    }
  }

  void onFilesSelected(List<String> paths) {
    setState(() {
      selectedFilePaths = paths;
    });
  }

  void _sendMessage(String text) {
    context.read<ConnectedChatCubit>().sendMessage(text: text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _receiveMessage(String text) {
    context.read<ConnectedChatCubit>().receiveMessage(encryptedText: text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatId = widget.payload.chatGeneralData.chatId;

    return FuzzyScaffold(
      hasAutomaticBackButton: false,
      body: BlocConsumer<ConnectedChatCubit, ConnectedChatState>(
        listener: (context, state) {
          if (state.status.isFailed) {
            if (state.failure?.message?.isEmpty ?? true) return;
            FuzzySnackbar.show(label: state.failure?.message ?? '');
          }
        },
        builder: (context, state) {
          return FileDropArea(
            onDropped: onFilesSelected,
            child: Stack(
              children: [
                CustomScrollView(
                  reverse: true,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 300),
                    ),
                    MessageListSliver(
                      messages: state.messages,
                    ),
                    if (state.status.isLoading)
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 24),
                      ),
                    if (state.status.isLoading)
                      const SliverToBoxAdapter(
                        child: DefaultLoadingWidget(),
                      ),
                    SliverToBoxAdapter(
                      child: FileDecryptionProgressesDisplaylaceholder(
                        chatId: chatId,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FileEncryptionProgressesDisplaylaceholder(
                        chatId: chatId,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ChatHeader(
                    chatGeneralData: widget.payload.chatGeneralData,
                    onBackPressed: () => context.pop(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_showTutorial)
                        _buildTutorialBanner(context, context.fuzzyChatLocalizations),
                      FileDecryptionProgressDisplay(
                        chatId: chatId,
                      ),
                      FileEncryptionProgressDisplay(
                        chatId: chatId,
                      ),
                      MessageInputField(
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        onSend: _onSend,
                        onFilesSelected: onFilesSelected,
                        selectedFilePaths: selectedFilePaths,
                        isEncrypting: isEncrypting,
                        chatId: chatId,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTutorialBanner(BuildContext context, FuzzyChatLocalizations localizations) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: uiColors.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: uiColors.diffColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.firstEncryption,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: uiColors.primaryTextColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  sl.get<PreferencesService>().setHasCompletedTutorial(true);
                  setState(() {
                    _showTutorial = false;
                  });
                },
                child: Icon(Icons.close, color: uiColors.primaryTextColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            localizations.typeAMessageAndPressSendItWillBeEncryptedLocallyAndYouCanThenCopyTheSecureFuzzedText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: uiColors.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

