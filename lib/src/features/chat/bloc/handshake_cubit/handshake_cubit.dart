import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/core/utils/keys_repository/key_storage_repository.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/features/chat/data/repositories/chat_general_data_list_repository.dart';

import '../../core/core.dart';

part 'handshake_state.dart';

class HandshakeCubit extends Cubit<HandshakeState> {
  HandshakeCubit({
    required this.handshakeManager,
    required this.keyStorageRepository,
    required this.chatGeneralDataListRepository,
  }) : super(const HandshakeState(status: StateStatus.initial));

  final HandshakeManager handshakeManager;
  final KeyStorageRepository keyStorageRepository;
  final ChatGeneralDataListRepository chatGeneralDataListRepository;

  Future<void> completeHandshake(String acceptanceContent) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final receivedAcceptance = await handshakeManager.parseAcceptance(acceptanceContent);
      final chatId = receivedAcceptance.chatId;
      final otherPartyPublicKey = receivedAcceptance.publicKey;
      final encryptedSymmetricKey = receivedAcceptance.encryptedSymmetricKey;

      final privateKey = await keyStorageRepository.getPrivateKey(chatId);
      if (privateKey == null) {
        emit(
          state.copyWith(
            status: StateStatus.failed,
            failure: DefaultFailure(
              message: 'Inviter private key not found',
            ),
          ),
        );
        return;
      }

      final symmetricKeyBase64 = await RSAManager.decrypt(
        encryptedSymmetricKey,
        privateKey,
      );
      final symmetricKey = base64Decode(symmetricKeyBase64);

      await keyStorageRepository.saveSymmetricKey(chatId, symmetricKey);
      await keyStorageRepository.saveOtherPartyPublicKey(chatId, otherPartyPublicKey);

      final chatData = await chatGeneralDataListRepository.getChatById(chatId);
      if (chatData != null) {
        final updatedChatData = chatData.copyWith(setupStatus: ChatSetupStatus.connected);
        await chatGeneralDataListRepository.updateChat(updatedChatData);
      }

      emit(
        state.copyWith(
          status: StateStatus.success,
          chatId: chatId,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(),
        ),
      );
    }
  }
}
