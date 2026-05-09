import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

part 'vault_auth_state.dart';

class VaultAuthCubit extends Cubit<VaultAuthState> {
  VaultAuthCubit({
    required this.cryptoRepository,
    required this.vaultRepository,
  }) : super(const VaultAuthState());

  final VaultCryptoRepository cryptoRepository;
  final VaultRepository vaultRepository;
  Timer? _autoLockTimer;

  Future<void> checkVaultStatus() async {
    emit(state.copyWith(status: StateStatus.loading));
    final metaRes = await vaultRepository.getMetadata();
    if (metaRes is VaultSuccess) {
      emit(state.copyWith(
        status: StateStatus.success,
        authState: VaultAuthEnum.locked,
      ),);
    } else {
      emit(state.copyWith(
        status: StateStatus.success,
        authState: VaultAuthEnum.noVault,
      ),);
    }
  }

  Future<void> createVault(String password) async {
    emit(state.copyWith(status: StateStatus.loading));
    
    final initRes = await cryptoRepository.initializeVault(password);
    if (initRes is VaultFailure) {
      emit(state.copyWith(
        status: StateStatus.failed,
        failureType: (initRes as VaultFailure).type,
      ),);
      return;
    }
    
    final metadata = (initRes as VaultSuccess<VaultMetadata>).data;
    final saveRes = await vaultRepository.saveMetadata(metadata);
    
    if (saveRes is VaultFailure) {
      emit(state.copyWith(
        status: StateStatus.failed,
        failureType: saveRes.type,
      ),);
      return;
    }

    final keyRes = await cryptoRepository.verifyAndDeriveKey(password, metadata);
    if (keyRes is VaultFailure) {
      emit(state.copyWith(
        status: StateStatus.failed,
        failureType: (keyRes as VaultFailure).type,
      ),);
      return;
    }

    final masterKey = (keyRes as VaultSuccess<Uint8List>).data;
    _startAutoLockTimer(metadata.autoLockMinutes);

    emit(state.copyWith(
      status: StateStatus.success,
      authState: VaultAuthEnum.unlocked,
      masterKey: masterKey,
    ),);
  }

  Future<void> unlock(String password) async {
    emit(state.copyWith(status: StateStatus.loading, authState: VaultAuthEnum.unlocking));
    
    final metaRes = await vaultRepository.getMetadata();
    if (metaRes is VaultFailure) {
      emit(state.copyWith(
        status: StateStatus.failed,
        failureType: (metaRes as VaultFailure).type,
        authState: VaultAuthEnum.locked,
      ),);
      return;
    }

    final metadata = (metaRes as VaultSuccess<VaultMetadata>).data;
    final keyRes = await cryptoRepository.verifyAndDeriveKey(password, metadata);
    
    if (keyRes is VaultFailure) {
      emit(state.copyWith(
        status: StateStatus.failed,
        failureType: (keyRes as VaultFailure).type,
        authState: VaultAuthEnum.locked,
      ),);
      return;
    }

    final masterKey = (keyRes as VaultSuccess<Uint8List>).data;
    
    final updatedMetadata = metadata.copyWith(lastUnlockedAt: DateTime.now());
    await vaultRepository.saveMetadata(updatedMetadata);
    
    _startAutoLockTimer(updatedMetadata.autoLockMinutes);

    emit(state.copyWith(
      status: StateStatus.success,
      authState: VaultAuthEnum.unlocked,
      masterKey: masterKey,
    ),);
  }

  void lock() {
    _autoLockTimer?.cancel();
    final keyToWipe = state.masterKey;
    if (keyToWipe != null && keyToWipe.isNotEmpty) {
      keyToWipe.fillRange(0, keyToWipe.length, 0);
    }
    emit(state.copyWith(
      status: StateStatus.success,
      authState: VaultAuthEnum.locked,
      masterKey: Uint8List(0),
    ),);
  }

  void _startAutoLockTimer(int minutes) {
    _autoLockTimer?.cancel();
    if (minutes <= 0) return;
    _autoLockTimer = Timer(Duration(minutes: minutes), lock);
  }

  @override
  Future<void> close() {
    _autoLockTimer?.cancel();
    return super.close();
  }
}
