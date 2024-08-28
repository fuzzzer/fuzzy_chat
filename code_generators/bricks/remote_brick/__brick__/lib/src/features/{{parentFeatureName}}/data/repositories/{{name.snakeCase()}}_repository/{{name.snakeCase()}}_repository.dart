import 'package:commons/http_client.dart';
import 'package:marketplace/marketplace.dart';
import 'responses/responses.dart';
import '../../models/{{modelName.snakeCase()}}.dart';

export 'responses/responses.dart';

class {{name.pascalCase()}}Repository {

  {{name.pascalCase()}}Repository();

  Future<{{functionName.pascalCase()}}Response> {{functionName.camelCase()}}() async {
   //TODO use proper data storage to get/store/modify the data
  }

  {{modelName.pascalCase()}} _parse{{modelName.pascalCase()}}(Map<String, dynamic> map) {
    return {{modelName.pascalCase()}}(
      id: 'TO CHANGE',
    );
  }
}
