import '../../storage/local_data_sources/{{modelName.snakeCase()}}_local_data_source.dart';
import '../models/{{modelName.snakeCase()}}.dart';
import '../../storage/storage_models/stored_{{modelName.snakeCase()}}.dart';


class {{modelName.pascalCase()}}Repository {
  final {{modelName.pascalCase()}}LocalDataSource localDataSource;

  {{modelName.pascalCase()}}Repository({required this.localDataSource});

  Future<{{modelName.pascalCase()}}?> get{{modelName.pascalCase()}}() async {
    final storedItem = await localDataSource.get();
    if (storedItem != null) {
      return {{modelName.pascalCase()}}.fromStored(storedItem);
    }
    return null;
  }

  Future<void> update{{modelName.pascalCase()}}({{modelName.pascalCase()}} item) async {
    await localDataSource.update(item);
  }

  Future<void> delete{{modelName.pascalCase()}}() async {
    await localDataSource.delete();
  }
}
