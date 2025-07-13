import '../../storage/storage_models/stored_{{modelName.snakeCase()}}.dart';

class {{modelName.pascalCase()}} {
  // TODO: Add the properties for your model here.
  final String name;
  // final bool isEnabled;
  final DateTime lastUpdated;

  {{modelName.pascalCase()}}({
    required this.name,
    // required this.isEnabled,
    required this.lastUpdated,
  });

  factory {{modelName.pascalCase()}}.fromStored(Stored{{modelName.pascalCase()}} stored) {
    return {{modelName.pascalCase()}}(
      // TODO: Map properties from stored model.
      name: stored.name,
      // isEnabled: stored.isEnabled,
      lastUpdated: stored.lastUpdated,
    );
  }

  {{modelName.pascalCase()}} copyWith({
    String? name,
    // bool? isEnabled,
    DateTime? lastUpdated,
  }) {
    return {{modelName.pascalCase()}}(
      name: name ?? this.name,
      // isEnabled: isEnabled ?? this.isEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
