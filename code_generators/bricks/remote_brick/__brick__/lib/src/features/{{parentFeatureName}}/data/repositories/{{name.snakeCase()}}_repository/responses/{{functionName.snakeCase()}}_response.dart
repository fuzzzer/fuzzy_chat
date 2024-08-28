import '../../../models/{{modelName.snakeCase()}}.dart';

sealed class {{functionName.pascalCase()}}Response {}

class {{functionName.pascalCase()}}Success extends {{functionName.pascalCase()}}Response {
  final {{modelName.pascalCase()}} {{modelName.camelCase()}};

  {{functionName.pascalCase()}}Success({
    required this.{{modelName.camelCase()}},
  });
}

class {{functionName.pascalCase()}}Failure extends {{functionName.pascalCase()}}Response {
  final String? message;

  {{functionName.pascalCase()}}Failure({
    this.message,
  });
}
