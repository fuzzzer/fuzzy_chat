part of '{{name.snakeCase()}}_cubit.dart';

class {{name.pascalCase()}}State {
  final StateStatus status;
  final List<{{modelName.pascalCase()}}> items;
  final DefaultFailure? failure;

  const {{name.pascalCase()}}State({
    this.status = StateStatus.initial,
    this.items = const [],
    this.failure,
  });

  {{name.pascalCase()}}State copyWith({
    StateStatus? status,
    List<{{modelName.pascalCase()}}>? items,
    DefaultFailure? failure,
  }) {
    return {{name.pascalCase()}}State(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure ?? this.failure,
    );
  }
}
