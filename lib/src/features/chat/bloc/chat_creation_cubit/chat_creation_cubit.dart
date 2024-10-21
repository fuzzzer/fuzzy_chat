import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';

part 'chat_creation_state.dart';

class ChatCreationCubit extends Cubit<ChatCreationState> {
  ChatCreationCubit({
    required this.handshakeManager,
    required this.keyStorageRepository,
    required this.chatGeneralDataListRepository,
  }) : super(const ChatCreationState(status: StateStatus.initial));

  final HandshakeManager handshakeManager;
  final KeyStorageRepository keyStorageRepository;
  final ChatGeneralDataListRepository chatGeneralDataListRepository;

  Future<void> createChat(String chatName) async {
    emit(state.copyWith(status: StateStatus.loading, chatName: chatName));

    try {
      final keyPair = await RSAManager.generateRSAKeyPair();
      final chatId = generateId();

      final chatData = ChatGeneralData(
        chatId: chatId,
        chatName: chatName,
        setupStatus: ChatSetupStatus.invited,
      );
      await chatGeneralDataListRepository.addChat(chatData);

      await keyStorageRepository.savePrivateKey(chatId, keyPair.privateKey);
      await keyStorageRepository.savePublicKey(chatId, keyPair.publicKey);

      final invitation = await handshakeManager.generateInvitation(chatId, keyPair.publicKey);

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
          failure: DefaultFailure(),
        ),
      );
    }
  }
}
