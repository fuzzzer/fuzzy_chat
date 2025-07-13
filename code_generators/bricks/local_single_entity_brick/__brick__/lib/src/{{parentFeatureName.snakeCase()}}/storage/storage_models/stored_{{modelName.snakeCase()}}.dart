import 'package:isar/isar.dart';

part 'stored_{{modelName.snakeCase()}}.g.dart';

// TODO: Run 'flutter pub run build_runner build' to generate the .g.dart file

@Collection()
class Stored{{modelName.pascalCase()}} {
  // Use a fixed ID for a singleton object pattern. This ensures you only
  // ever have one of this object in the database.
  final Id id = 1;

  // TODO: Add the properties for your model here.
  late String name;
  // late bool isEnabled;

  late DateTime lastUpdated;
}
