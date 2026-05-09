import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'connected_chat_state.dart';

class ConnectedChatCubit extends Cubit<ConnectedChatState> {
  ConnectedChatCubit({
    required this.messageDataRepository,
    required this.keyStorageRepository,
    required this.chatId,
    this.chatSymmetricKey,
    this.messagesPerPage = 8,
  }) : super(
          const ConnectedChatState(
            status: StateStatus.initial,
            messages: [],
          ),
        ) {
    _newMessageUpdatesSubscription = messageDataRepository.newMessageUpdates
        .listen(addNewMessageInBackground);
  }

  late final StreamSubscription<NewMessageAdded> _newMessageUpdatesSubscription;

  final MessageDataRepository messageDataRepository;
  final KeyStorageRepository keyStorageRepository;

  final String chatId;
  Uint8List? chatSymmetricKey;

  final int messagesPerPage;
  int currentPage = 0;

  @override
  Future<void> close() {
    _newMessageUpdatesSubscription.cancel();
    return super.close();
  }

  Future<void> addNewMessageInBackground(
      NewMessageAdded newMessageAdded) async {
    emit(
      state.copyWith(
        messages: [
          newMessageAdded.message,
          ...state.messages,
        ],
      ),
    );
  }

  Future<void> loadInitialMessages() async {
    emit(
      state.copyWith(
        hasFetchedAllMessages: false,
      ),
    );
    currentPage = 0;

    await loadCurrentMessagesPage();
  }

  Future<void> loadOlderMessages() async {
    if (state.status.isLoading || state.hasFetchedAllMessages) return;
    currentPage++;
    await loadCurrentMessagesPage();
  }

  Future<void> loadCurrentMessagesPage() async {
    emit(
      state.copyWith(
        status: StateStatus.loading,
      ),
    );

    try {
      final paginatedMessages =
          await messageDataRepository.getMessagesForChatPaginated(
        chatId,
        pageSize: messagesPerPage,
        pageIndex: currentPage,
      );

      if (paginatedMessages.isEmpty) {
        emit(
          state.copyWith(
            status: StateStatus.success,
            hasFetchedAllMessages: true,
          ),
        );
        return;
      }

      chatSymmetricKey = chatSymmetricKey ??
          await keyStorageRepository.getSymmetricKey(chatId);

      if (chatSymmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      final symmetricKey = chatSymmetricKey!;

      final decryptedMessages = await Future.wait(
        paginatedMessages.map((message) async {
          if (message.type.isText) {
            final decryptedMessage = await AESService.decryptText(
              message.encryptedMessage,
              symmetricKey,
            );
            return message.copyWith(decryptedMessage: decryptedMessage);
          } else {
            return message.copyWith(
              decryptedMessage: message.encryptedMessage,
            );
          }
        }),
      );

      // Append newly loaded messages to the existing list
      final updatedMessages = [
        ...state.messages,
        ...decryptedMessages,
      ];

      emit(
        state.copyWith(
          status: StateStatus.success,
          messages: updatedMessages,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(
            message: ex.toString(),
          ),
        ),
      );
    }
  }

  Future<void> sendMessage({
    required String text,
  }) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.sendMessage,
      ),
    );

    try {
      chatSymmetricKey = chatSymmetricKey ??
          await keyStorageRepository.getSymmetricKey(chatId);

      if (chatSymmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      final symmetricKey = chatSymmetricKey!;

      final encryptedMessage = await AESService.encryptText(text, symmetricKey);

      final message = MessageData(
        id: 0,
        type: MessageType.text,
        chatId: chatId,
        encryptedMessage: encryptedMessage,
        decryptedMessage: text,
        sentAt: DateTime.now(),
        isSent: true,
      );

      final newMessageId = await messageDataRepository.addMessage(message);

      final preparedNewMessage = message.copyWith(
        id: newMessageId,
        sentAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [
            preparedNewMessage,
            ...state.messages,
          ],
          actionStatus: StateStatus.success,
          actionType: ChatActionType.sendMessage,
        ),
      );
    } catch (ex) {
      logger.e('ERROR: $ex');

      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ChatActionType.sendMessage,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> receiveMessage({
    required String encryptedText,
  }) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.receiveMessage,
      ),
    );

    try {
      chatSymmetricKey = chatSymmetricKey ??
          await keyStorageRepository.getSymmetricKey(chatId);

      if (chatSymmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      final symmetricKey = chatSymmetricKey!;

      final decryptedMessage =
          await AESService.decryptText(encryptedText, symmetricKey);

      final message = MessageData(
        id: 0,
        chatId: chatId,
        type: MessageType.text,
        encryptedMessage: encryptedText,
        decryptedMessage: decryptedMessage,
        sentAt: DateTime.now(),
        isSent: false,
      );

      final newMessageId = await messageDataRepository.addMessage(message);

      final preparedNewMessage = message.copyWith(
        id: newMessageId,
        sentAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [
            preparedNewMessage,
            ...state.messages,
          ],
          actionStatus: StateStatus.success,
          actionType: ChatActionType.receiveMessage,
        ),
      );
    } catch (ex) {
      logger.e('ERROR: $ex');

      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ChatActionType.receiveMessage,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> deleteMessage({
    required int messageId,
  }) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.deleteMessage,
      ),
    );

    try {
      await messageDataRepository.deleteMessage(messageId);

      final updatedMessages =
          state.messages.where((message) => message.id != messageId).toList();
      emit(
        state.copyWith(
          messages: updatedMessages,
          actionStatus: StateStatus.success,
          actionType: ChatActionType.deleteMessage,
        ),
      );
    } catch (ex) {
      logger.e('ERROR: $ex');

      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ChatActionType.deleteMessage,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> deleteAllMessages() async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.deleteAllMessages,
      ),
    );

    try {
      await messageDataRepository.deleteAllMessagesForChat(chatId);

      emit(
        state.copyWith(
          messages: [],
          actionStatus: StateStatus.success,
          actionType: ChatActionType.deleteAllMessages,
        ),
      );
    } catch (ex) {
      logger.e('ERROR: $ex');

      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ChatActionType.deleteAllMessages,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }
}
