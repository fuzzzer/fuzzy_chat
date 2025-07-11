import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'chat_creation_state.dart';

class ChatCreationCubit extends Cubit<ChatCreationState> {
  ChatCreationCubit({
    required this.keyStorageRepository,
    required this.chatGeneralDataListRepository,
  }) : super(const ChatCreationState(status: StateStatus.initial));

  final KeyStorageRepository keyStorageRepository;
  final ChatGeneralDataListRepository chatGeneralDataListRepository;

  Future<void> createChat({
    required String chatName,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, chatName: chatName));

    try {
      final restriction = await checkChatNameRestrictions(chatName);

      if (restriction != null) {
        emit(
          state.copyWith(
            status: StateStatus.failed,
            failure: ChatCreationFailure(
              type: restriction,
            ),
          ),
        );
        return;
      }

      final keyPair = await RSAService.generateRSAKeyPair();
      final chatId = generateId();

      final chatData = ChatGeneralData(
        chatId: chatId,
        chatName: chatName,
        setupStatus: ChatSetupStatus.invited,
        didAcceptInvitation: false,
      );
      await chatGeneralDataListRepository.addChat(chatData);

      await keyStorageRepository.savePrivateKey(chatId, keyPair.privateKey);
      await keyStorageRepository.savePublicKey(chatId, keyPair.publicKey);

      final invitation = await HandshakeService.generateInvitation(chatId, keyPair.publicKey);

      emit(
        state.copyWith(
          status: StateStatus.success,
          chatId: chatId,
          generatedChatInvitation: invitation,
        ),
      );
    } catch (ex) {
      logger.e('ERROR: $ex');

      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: ChatCreationFailure(
            internalMessage: ex.toString(),
            type: ChatCreationFailureType.unknown,
          ),
        ),
      );
    }
  }

  Future<ChatCreationFailureType?> checkChatNameRestrictions(String chatName) async {
    final name = await chatGeneralDataListRepository.getChatByName(chatName);

    if (name != null) {
      return ChatCreationFailureType.existingName;
    }

    return null;
  }
}
