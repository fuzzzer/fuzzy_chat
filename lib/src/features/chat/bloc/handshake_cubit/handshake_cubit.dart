import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/core/utils/keys_repository/key_storage_repository.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:fuzzy_chat/src/features/chat/data/repositories/chat_general_data_list_repository.dart';

part 'handshake_state.dart';

class HandshakeCubit extends Cubit<HandshakeState> {
  HandshakeCubit({
    required this.chatGeneralDataListRepository,
    required this.keyStorageRepository,
  }) : super(const HandshakeState(status: StateStatus.initial));

  final ChatGeneralDataListRepository chatGeneralDataListRepository;
  final KeyStorageRepository keyStorageRepository;

  Future<void> completeHandshake(String acceptanceContent) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final acceptanceData = jsonDecode(acceptanceContent) as Map<String, dynamic>;
      final chatId = acceptanceData['chatId'] as String;
      final recipientPublicKeyMap = acceptanceData['publicKey'] as Map<String, String>;
      final encryptedSymmetricKey = acceptanceData['encryptedSymmetricKey'] as String;

      final inviterPrivateKey = await keyStorageRepository.getPrivateKey(chatId);
      if (inviterPrivateKey == null) {
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
        inviterPrivateKey,
      );
      final symmetricKey = base64Decode(symmetricKeyBase64);

      final recipientPublicKey = RSAManager.transformMapToRSAPublicKey(recipientPublicKeyMap);
      await keyStorageRepository.saveRecipientPublicKey(chatId, recipientPublicKey);

      await keyStorageRepository.saveSymmetricKey(chatId, symmetricKey);

      final chatData = await chatGeneralDataListRepository.getChatById(chatId);
      if (chatData != null) {
        final updatedChatData = chatData.copyWith(setupStatus: ChatSetupStatus.connected);
        await chatGeneralDataListRepository.updateChat(updatedChatData);
      }

      emit(state.copyWith(status: StateStatus.success, chatId: chatId));
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
