import 'package:isar/isar.dart';

import '../../data/models/{{modelName.snakeCase()}}.dart';
import '../storage_models/stored_{{modelName.snakeCase()}}.dart';

class {{modelName.pascalCase()}}LocalDataSource {
  final Isar isar;

  {{modelName.pascalCase()}}LocalDataSource({required this.isar});

  Future<Stored{{modelName.pascalCase()}}?> get() async {
    return isar.stored{{modelName.pascalCase()}}s.get(1);
  }

  Future<void> update({{modelName.pascalCase()}} model) async {
    final storedModel = Stored{{modelName.pascalCase()}}()
      ..name = model.name
      ..lastUpdated = DateTime.now();
      // ..isEnabled = model.isEnabled;

    await isar.writeTxn(() async {
      await isar.stored{{modelName.pascalCase()}}s.put(storedModel);
    });
  }

  Future<bool> delete() async {
    return isar.writeTxn(() async {
      return isar.stored{{modelName.pascalCase()}}s.delete(1);
    });
  }
}
