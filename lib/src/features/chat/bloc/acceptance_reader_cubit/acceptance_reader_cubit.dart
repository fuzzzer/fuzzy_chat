import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/src/core/core.dart';
import 'package:fuzzy_chat/src/features/chat/core/core.dart';

part 'acceptance_reader_state.dart';

class AcceptanceReaderCubit extends Cubit<AcceptanceReaderState> {
  AcceptanceReaderCubit({
    required this.handshakeManager,
    required this.keyStorageRepository,
  }) : super(const AcceptanceReaderState(status: StateStatus.initial));

  final HandshakeManager handshakeManager;
  final KeyStorageRepository keyStorageRepository;

  Future<void> generateAcceptance({
    required String chatId,
  }) async {
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final otherPartyPublicKey = await keyStorageRepository.getOtherPartyPublicKey(chatId);
      final symmetricKey = await keyStorageRepository.getSymmetricKey(chatId);

      if (otherPartyPublicKey == null || symmetricKey == null) {
        emit(
          state.copyWith(
            status: StateStatus.failed,
            failure: DefaultFailure(message: 'Public or symmetric key not found.'),
          ),
        );
        return;
      }

      final encryptedSymmetricKey = await RSAManager.encrypt(
        symmetricKey,
        otherPartyPublicKey,
      );

      final acceptance = await handshakeManager.generateAcceptance(
        chatId: chatId,
        otherPartyPublicKey: otherPartyPublicKey,
        encryptedSymmetricKey: encryptedSymmetricKey,
      );

      emit(
        state.copyWith(
          status: StateStatus.success,
          acceptance: acceptance,
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
