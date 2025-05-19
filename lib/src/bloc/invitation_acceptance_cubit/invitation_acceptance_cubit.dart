import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'invitation_acceptance_state.dart';

class InvitationAcceptanceCubit extends Cubit<InvitationAcceptanceState> {
  InvitationAcceptanceCubit({
    required this.chatGeneralDataListRepository,
    required this.keyStorageRepository,
  }) : super(
          const InvitationAcceptanceState(
            status: StateStatus.initial,
          ),
        );

  final ChatGeneralDataListRepository chatGeneralDataListRepository;
  final KeyStorageRepository keyStorageRepository;

  Future<void> acceptInvitation({
    required String invitationContent,
    required String chatName,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

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

      final receivedInvitation = await HandshakeService.parseInvitation(invitationContent);
      final chatId = generateId();
      final otherPartyPublicKey = receivedInvitation.publicKey;

      final keyPair = await RSAService.generateRSAKeyPair();
      final symmetricKey = await AESService.generateKey();

      final encryptedSymmetricKey = await RSAService.encrypt(
        symmetricKey,
        otherPartyPublicKey,
      );

      await keyStorageRepository.savePrivateKey(chatId, keyPair.privateKey);
      await keyStorageRepository.savePublicKey(chatId, keyPair.publicKey);
      await keyStorageRepository.saveSymmetricKey(chatId, symmetricKey);
      await keyStorageRepository.saveOtherPartyPublicKey(chatId, otherPartyPublicKey);

      final acceptance = await HandshakeService.generateAcceptance(
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
