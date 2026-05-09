part of 'vault_search_cubit.dart';

class VaultSearchState {
  const VaultSearchState({
    this.status = StateStatus.initial,
    this.query = '',
    this.results = const [],
    this.failureType,
  });

  final StateStatus status;
  final String query;
  final List<VaultItemMetadata> results;
  final VaultFailureType? failureType;

  VaultSearchState copyWith({
    StateStatus? status,
    String? query,
    List<VaultItemMetadata>? results,
    VaultFailureType? failureType,
  }) {
    return VaultSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      failureType: failureType ??
          (status == StateStatus.success ? null : this.failureType),
    );
  }
}
