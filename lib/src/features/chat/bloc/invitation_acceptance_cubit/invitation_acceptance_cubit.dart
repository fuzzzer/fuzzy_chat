// invitation_acceptance_cubit.dart

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/core/utils/keys_repository/key_storage_repository.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../data/repositories/chat_general_data_list_repository.dart';

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

  Future<void> acceptInvitation(String invitationContent) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final invitationData = jsonDecode(invitationContent) as Map<String, dynamic>;
      final chatId = invitationData['chatId'] as String;
      final inviterPublicKeyMap = invitationData['publicKey'] as String;

      final inviterPublicKey = RSAManager.transformMapToRSAPublicKey(
        jsonDecode(inviterPublicKeyMap) as Map<String, String>,
      );

      final recipientKeyPair = await RSAManager.generateRSAKeyPair();

      final symmetricKey = await AESManager.generateKey();

      final encryptedSymmetricKey = await RSAManager.encrypt(
        base64Encode(symmetricKey),
        inviterPublicKey,
      );

      await keyStorageRepository.savePrivateKey(chatId, recipientKeyPair.privateKey);
      await keyStorageRepository.savePublicKey(chatId, recipientKeyPair.publicKey);
      await keyStorageRepository.saveSymmetricKey(chatId, symmetricKey);
      await keyStorageRepository.saveRecipientPublicKey(chatId, inviterPublicKey);

      await createAcceptanceFile(
        chatId: chatId,
        recipientPublicKey: recipientKeyPair.publicKey,
        encryptedSymmetricKey: encryptedSymmetricKey,
      );

      final chatData = ChatGeneralData(
        chatId: chatId,
        chatName: 'Chat with $chatId',
        setupStatus: ChatSetupStatus.invited,
      );
      await chatGeneralDataListRepository.addChat(chatData);

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

  Future<void> createAcceptanceFile({
    required String chatId,
    required RSAPublicKey recipientPublicKey,
    required String encryptedSymmetricKey,
  }) async {
    final recipientPublicKeyMap = RSAManager.transformRSAPublicKeyToMap(recipientPublicKey);

    final acceptanceData = {
      'chatId': chatId,
      'publicKey': recipientPublicKeyMap,
      'encryptedSymmetricKey': encryptedSymmetricKey,
    };

    final acceptanceJson = jsonEncode(acceptanceData);

    await saveFile('chat_acceptance_$chatId.fuzz', acceptanceJson);
  }

  Future<void> saveFile(String fileName, String content) async {
    // Implement file saving logic here
    // This could involve using path_provider and dart:io
  }
}
