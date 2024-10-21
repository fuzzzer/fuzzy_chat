import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';

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

  Future<void> completeHandshake({
    required String acceptanceContent,
    required String chatId,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final receivedAcceptance = await handshakeManager.parseAcceptance(acceptanceContent);
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

      final symmetricKey = await RSAManager.decrypt(
        encryptedSymmetricKey,
        privateKey,
      );

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
          chatData: chatData,
        ),
      );
    } catch (ex) {
      logger.e('ERROR: $ex');

      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(),
        ),
      );
    }
  }
}
