import 'package:uuid/uuid.dart';

String generateId() {
  return const Uuid().v4();
}
