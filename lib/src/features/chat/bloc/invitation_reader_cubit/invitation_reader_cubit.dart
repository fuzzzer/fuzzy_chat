import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/core/core.dart';

part 'invitation_reader_state.dart';

class InvitationReaderCubit extends Cubit<InvitationReaderState> {
  InvitationReaderCubit({
    required this.handshakeManager,
    required this.keyStorageRepository,
  }) : super(const InvitationReaderState(status: StateStatus.initial));

  final HandshakeManager handshakeManager;
  final KeyStorageRepository keyStorageRepository;

  Future<void> generateInvitation(String chatId) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final publicKey = await keyStorageRepository.getPublicKey(chatId);
      if (publicKey == null) {
        emit(
          state.copyWith(
            status: StateStatus.failed,
            failure: DefaultFailure(message: 'Public key not found.'),
          ),
        );
        return;
      }

      final invitation = await handshakeManager.generateInvitation(chatId, publicKey);

      emit(
        state.copyWith(
          status: StateStatus.success,
          invitation: invitation,
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
