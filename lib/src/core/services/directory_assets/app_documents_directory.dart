import 'dart:io';

///Directory for users to access, copy files, get resources and,
///all app generated content for the user
class AppDocumentsDirectory {
  final Directory directory;

  AppDocumentsDirectory({
    required this.directory,
  });

  @override
  String toString() {
    return directory.path;
  }
}
