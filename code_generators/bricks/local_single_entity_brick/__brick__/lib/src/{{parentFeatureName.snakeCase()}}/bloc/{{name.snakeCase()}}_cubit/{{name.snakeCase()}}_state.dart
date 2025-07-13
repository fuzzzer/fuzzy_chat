part of '{{name.snakeCase()}}_cubit.dart';

class {{name.pascalCase()}}State {
  final StateStatus status;
  final {{modelName.pascalCase()}}? item;
  final DefaultFailure? failure;

  const {{name.pascalCase()}}State({
    this.status = StateStatus.initial,
    this.item,
    this.failure,
  });

  {{name.pascalCase()}}State copyWith({
    StateStatus? status,
    {{modelName.pascalCase()}}? item,
    DefaultFailure? failure,
  }) {
    return {{name.pascalCase()}}State(
      status: status ?? this.status,
      item: item ?? this.item,
      failure: failure ?? this.failure,
    );
  }
}
