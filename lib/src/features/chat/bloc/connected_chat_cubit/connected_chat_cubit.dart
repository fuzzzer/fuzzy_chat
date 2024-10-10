import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/core/utils/keys_repository/key_storage_repository.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';

import '../../data/repositories/message_data_repository.dart';

part 'connected_chat_state.dart';

class ConnectedChatCubit extends Cubit<ConnectedChatState> {
  ConnectedChatCubit({
    required this.chatId,
    required this.messageDataRepository,
    required this.keyStorageRepository,
  }) : super(
          const ConnectedChatState(
            status: StateStatus.initial,
            messages: [],
          ),
        );

  final String chatId;
  final MessageDataRepository messageDataRepository;
  final KeyStorageRepository keyStorageRepository;

  Future<void> loadMessages() async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final storedMessages = await messageDataRepository.getMessagesForChat(chatId);
      final symmetricKey = await keyStorageRepository.getSymmetricKey(chatId);
      if (symmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      final messages = await Future.wait(
        storedMessages.map((message) async {
          final decryptedMessage = await AESManager.decrypt(
            message.encryptedMessage,
            symmetricKey,
          );

          return message.copyWith(
            decryptedMessage: decryptedMessage,
          );
        }),
      );

      emit(state.copyWith(status: StateStatus.success, messages: messages));
    } catch (ex) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> sendMessage(String plaintext) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.sendMessage,
      ),
    );

    try {
      final symmetricKey = await keyStorageRepository.getSymmetricKey(chatId);
      if (symmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      final encryptedMessage = await AESManager.encrypt(plaintext, symmetricKey);

      final message = MessageData(
        id: 0,
        chatId: chatId,
        encryptedMessage: encryptedMessage,
        decryptedMessage: plaintext,
        sentAt: DateTime.now(),
        isSent: true,
      );

      final newMessageId = await messageDataRepository.addMessage(message);

      final updatedMessages = List<MessageData>.from(state.messages)
        ..add(
          message.copyWith(
            id: newMessageId,
          ),
        );

      emit(
        state.copyWith(
          messages: updatedMessages,
          actionStatus: StateStatus.success,
          actionType: ChatActionType.sendMessage,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ChatActionType.sendMessage,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> receiveMessage(String encryptedMessage) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.receiveMessage,
      ),
    );

    try {
      final symmetricKey = await keyStorageRepository.getSymmetricKey(chatId);
      if (symmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      final decryptedMessage = await AESManager.decrypt(encryptedMessage, symmetricKey);

      final message = MessageData(
        id: 0,
        chatId: chatId,
        encryptedMessage: encryptedMessage,
        decryptedMessage: decryptedMessage,
        sentAt: DateTime.now(),
        isSent: false,
      );

      final newMessageId = await messageDataRepository.addMessage(message);

      final updatedMessages = List<MessageData>.from(state.messages)
        ..add(
          message.copyWith(
            id: newMessageId,
          ),
        );

      emit(
        state.copyWith(
          messages: updatedMessages,
          actionStatus: StateStatus.success,
          actionType: ChatActionType.receiveMessage,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ChatActionType.receiveMessage,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> deleteMessage(int messageId) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ChatActionType.deleteMessage,
      ),
    );

    try {
      await messageDataRepository.deleteMessage(messageId);

      final updatedMessages = state.messages.where((message) => message.id != messageId).toList();
      emit(
        state.copyWith(
          messages: updatedMessages,
          actionStatus: StateStatus.success,
          actionType: ChatActionType.deleteMessage,
        ),
      );
    } catch (ex) {
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
