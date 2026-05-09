import 'vault_failure_type.dart';

sealed class VaultResponse<T> {
  const VaultResponse();
}

class VaultSuccess<T> extends VaultResponse<T> {
  const VaultSuccess(this.data);
  final T data;
}

class VaultFailure<T> extends VaultResponse<T> {
  const VaultFailure(this.type, {this.message});
  final VaultFailureType type;
  final String? message;
}
