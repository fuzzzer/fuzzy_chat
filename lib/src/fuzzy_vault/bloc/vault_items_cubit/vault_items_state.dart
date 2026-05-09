part of 'vault_items_cubit.dart';

class VaultItemsState {
  const VaultItemsState({
    this.status = StateStatus.initial,
    this.items = const [],
    this.selectedGroupId,
    this.failureType,
  });

  final StateStatus status;
  final List<VaultItemMetadata> items;
  final String? selectedGroupId;
  final VaultFailureType? failureType;

  VaultItemsState copyWith({
    StateStatus? status,
    List<VaultItemMetadata>? items,
    String? selectedGroupId,
    VaultFailureType? failureType,
  }) {
    return VaultItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      failureType: failureType ??
          (status == StateStatus.success ? null : this.failureType),
    );
  }
}
