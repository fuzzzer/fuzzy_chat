import 'package:commons/core.dart';
import 'package:dependencies/bloc.dart';
import '../../data/models/{{modelName.snakeCase()}}.dart';
import '../../data/repositories/{{name.snakeCase()}}_repository/{{name.snakeCase()}}_repository.dart';

part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
  {{name.pascalCase()}}Cubit({
    required this.{{name.camelCase()}}Repository,
  }) : super(const {{name.pascalCase()}}State(
          status: StateStatus.initial,
        ));

  final {{name.pascalCase()}}Repository {{name.camelCase()}}Repository;

  Future<void> {{functionName.camelCase()}}() async {
    emit(state.copyWith(status: StateStatus.loading));

    final response = await {{name.camelCase()}}Repository.{{functionName.camelCase()}}();

    final newState = switch (response) {
      {{functionName.pascalCase()}}Success() => state.copyWith(
          status: StateStatus.success,
          {{modelName.camelCase()}}: response.{{modelName.camelCase()}},
        ),
      {{functionName.pascalCase()}}Failure() => state.copyWith(
          status: StateStatus.failed,
          failure: DefaultFailure(
            message: response.message,
          ),
        ),
    };

    emit(newState);
  }
}
