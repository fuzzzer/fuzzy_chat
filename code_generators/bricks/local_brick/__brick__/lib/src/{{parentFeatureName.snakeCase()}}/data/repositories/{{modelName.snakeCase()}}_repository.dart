import '../../storage/local_data_sources/{{modelName.snakeCase()}}_local_data_source.dart';
import '../models/{{modelName.snakeCase()}}.dart';

class {{modelName.pascalCase()}}Repository {
  final {{modelName.pascalCase()}}LocalDataSource localDataSource;

  {{modelName.pascalCase()}}Repository({required this.localDataSource});

  Future<List<{{modelName.pascalCase()}}>> getAll{{modelName.pascalCase()}}s() async {
    final storedItems = await localDataSource.getAll();
    return storedItems.map({{modelName.pascalCase()}}.fromStored).toList();
  }

  Future<{{modelName.pascalCase()}}?> get{{modelName.pascalCase()}}ByUid(String uid) async {
    final storedItem = await localDataSource.getByUid(uid);
    if (storedItem != null) {
      return {{modelName.pascalCase()}}.fromStored(storedItem);
    }
    return null;
  }

  Future<void> addOrUpdate{{modelName.pascalCase()}}({{modelName.pascalCase()}} item) async {
    await localDataSource.addOrUpdate(item);
  }

  Future<void> delete{{modelName.pascalCase()}}(String uid) async {
    await localDataSource.delete(uid);
  }
}
