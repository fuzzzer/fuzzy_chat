import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'invitation_reader_state.dart';

class InvitationReaderCubit extends Cubit<InvitationReaderState> {
  InvitationReaderCubit({
    required this.keyStorageRepository,
  }) : super(const InvitationReaderState(status: StateStatus.initial));

  final KeyStorageRepository keyStorageRepository;

  Future<void> generateInvitation({
    required String chatId,
  }) async {
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

      final invitation = await HandshakeService.generateInvitation(chatId, publicKey);

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
