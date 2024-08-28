part of '{{name.snakeCase()}}_cubit.dart';

class {{name.pascalCase()}}State {
  final StateStatus status;
  final {{modelName.pascalCase()}}? {{modelName.camelCase()}};
  final DefaultFailure? failure;

  const {{name.pascalCase()}}State({
    required this.status,
    this.{{modelName.camelCase()}},
    this.failure,
  });

  {{name.pascalCase()}}State copyWith({
    StateStatus? status,
    {{modelName.pascalCase()}}? {{modelName.camelCase()}},
    DefaultFailure? failure,
  }) {
    return {{name.pascalCase()}}State(
      status: status ?? this.status,
      {{modelName.camelCase()}}: {{modelName.camelCase()}} ?? this.{{modelName.camelCase()}},
      failure: failure ?? this.failure,
    );
  }
}
