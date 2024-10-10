import 'package:bloc/bloc.dart';
import 'package:fuzzy_chat/src/features/chat/chat.dart';

import '../../../../core/core.dart';
import '../../data/repositories/chat_general_data_list_repository.dart';

part 'chat_general_data_list_state.dart';

class ChatGeneralDataListCubit extends Cubit<ChatGeneralDataListState> {
  ChatGeneralDataListCubit({required this.chatRepository})
      : super(
          const ChatGeneralDataListState(
            status: StateStatus.initial,
          ),
        );

  final ChatGeneralDataListRepository chatRepository;

  Future<void> fetchChats() async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final chats = await chatRepository.getAllChats();

      emit(state.copyWith(status: StateStatus.success, chats: chats));
    } catch (ex) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> deleteChat(String chatId) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ActionType.delete,
      ),
    );

    try {
      await chatRepository.deleteChat(chatId);

      final updatedChats = state.chats?.where((chat) => chat.chatId != chatId).toList();

      emit(
        state.copyWith(
          chats: updatedChats,
          actionStatus: StateStatus.success,
          actionType: ActionType.delete,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ActionType.delete,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  Future<void> updateChat(ChatGeneralData chat) async {
    emit(
      state.copyWith(
        actionStatus: StateStatus.loading,
        actionType: ActionType.update,
      ),
    );

    try {
      await chatRepository.updateChat(chat);

      final updatedChats = state.chats?.map((existingChat) {
        return existingChat.chatId == chat.chatId ? chat : existingChat;
      }).toList();

      emit(
        state.copyWith(
          chats: updatedChats,
          actionStatus: StateStatus.success,
          actionType: ActionType.update,
        ),
      );
    } catch (ex) {
      emit(
        state.copyWith(
          actionStatus: StateStatus.failed,
          actionType: ActionType.update,
          actionFailure: DefaultFailure(),
        ),
      );
    }
  }

  void resetActionStatus() {
    emit(
      state.copyWith(
        actionStatus: StateStatus.initial,
        actionType: ActionType.none,
      ),
    );
  }
}
