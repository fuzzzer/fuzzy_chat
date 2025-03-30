import 'dart:io';

///Directory for system to access, hidden from user, to be used with databases caches,
///and all non visible content to the user
class AppSupportDirectory {
  final Directory directory;

  AppSupportDirectory({
    required this.directory,
  });

  @override
  String toString() {
    return directory.path;
  }
}
