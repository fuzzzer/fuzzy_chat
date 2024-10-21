import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';

part 'invitation_acceptance_state.dart';

class InvitationAcceptanceCubit extends Cubit<InvitationAcceptanceState> {
  InvitationAcceptanceCubit({
    required this.handshakeManager,
    required this.chatGeneralDataListRepository,
    required this.keyStorageRepository,
  }) : super(
          const InvitationAcceptanceState(
            status: StateStatus.initial,
          ),
        );

  final HandshakeManager handshakeManager;
  final ChatGeneralDataListRepository chatGeneralDataListRepository;
  final KeyStorageRepository keyStorageRepository;

  Future<void> acceptInvitation({
    required String invitationContent,
    required String chatName,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final receivedInvitation = await handshakeManager.parseInvitation(invitationContent);
      final chatId = generateId();
      final otherPartyPublicKey = receivedInvitation.publicKey;

      final keyPair = await RSAManager.generateRSAKeyPair();
      final symmetricKey = await AESManager.generateKey();

      final encryptedSymmetricKey = await RSAManager.encrypt(
        symmetricKey,
        otherPartyPublicKey,
      );

      await keyStorageRepository.savePrivateKey(chatId, keyPair.privateKey);
      await keyStorageRepository.savePublicKey(chatId, keyPair.publicKey);
      await keyStorageRepository.saveSymmetricKey(chatId, symmetricKey);
      await keyStorageRepository.saveOtherPartyPublicKey(chatId, otherPartyPublicKey);

      final acceptance = await handshakeManager.generateAcceptance(
        chatId: chatId,
        otherPartyPublicKey: keyPair.publicKey,
        encryptedSymmetricKey: encryptedSymmetricKey,
      );

      final chatData = ChatGeneralData(
        chatId: chatId,
        chatName: chatName,
        setupStatus: ChatSetupStatus.connected,
        didAcceptInvitation: true,
      );

      await chatGeneralDataListRepository.addChat(chatData);

      emit(
        state.copyWith(
          status: StateStatus.success,
          chatData: chatData,
          generatedAcceptance: acceptance,
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
