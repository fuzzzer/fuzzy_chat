import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'basic_encryption_state.dart';

class BasicEncryptionCubit extends Cubit<BasicEncryptionState> {
  BasicEncryptionCubit() : super(const BasicEncryptionState(status: StateStatus.initial));

  Uint8List _createKeyFromString(String textKey) {
    final keyBytes = utf8.encode(textKey);
    final digest = sha256.convert(keyBytes);
    return Uint8List.fromList(digest.bytes);
  }

  Future<void> encryptText({required String text, required String key}) async {
    if (text.isEmpty || key.isEmpty) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(message: 'textAndKeyCannotBeEmpty'),
        ),
      );
      return;
    }
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final symmetricKey = _createKeyFromString(key);
      final encryptedText = await AESService.encryptText(text, symmetricKey);
      emit(
        state.copyWith(
          status: StateStatus.success,
          result: encryptedText,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(message: 'encryptionFailed'),
        ),
      );
    }
  }

  Future<void> decryptText({required String encryptedText, required String key}) async {
    if (encryptedText.isEmpty || key.isEmpty) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(message: 'encryptedTextAndKeyCannotBeEmpty'),
        ),
      );
      return;
    }
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final symmetricKey = _createKeyFromString(key);
      final decryptedText = await AESService.decryptText(encryptedText, symmetricKey);
      emit(
        state.copyWith(
          status: StateStatus.success,
          result: decryptedText,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(message: 'decryptionFailedCheckYourKeyOrEncryptedText'),
        ),
      );
    }
  }
}
