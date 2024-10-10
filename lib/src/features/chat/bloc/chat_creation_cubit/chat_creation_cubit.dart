// chat_creation_cubit.dart

import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/core/utils/id_generator.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';
import 'package:pointycastle/export.dart';

import '../../../../core/utils/keys_repository/key_storage_repository.dart';
import '../../data/repositories/chat_general_data_list_repository.dart';

part 'chat_creation_state.dart';

class ChatCreationCubit extends Cubit<ChatCreationState> {
  ChatCreationCubit({
    required this.chatGeneralDataListRepository,
    required this.keyStorageRepository,
  }) : super(const ChatCreationState(status: StateStatus.initial));

  final ChatGeneralDataListRepository chatGeneralDataListRepository;
  final KeyStorageRepository keyStorageRepository;

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

      await createInvitationFile(chatId, keyPair.publicKey);

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

  Future<void> createInvitationFile(String chatId, RSAPublicKey publicKey) async {
    final publicKeyMap = RSAManager.transformRSAPublicKeyToMap(publicKey);

    final invitationData = {
      'chatId': chatId,
      'publicKey': publicKeyMap,
    };

    final invitationJson = jsonEncode(invitationData);

    await saveFile('chat_invitation_$chatId.fuzz', invitationJson);
  }

  Future<void> saveFile(String fileName, String content) async {
    //TODO implement
  }
}
