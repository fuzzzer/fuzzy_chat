import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class DeviceFileInteractor {
  static Future<void> openFile(String filePath) async {
    final file = File(filePath);
    final fileExists = await file.exists();
    if (!fileExists) {
      throw FileSystemException('File does not exist', filePath);
    }

    final uri = Uri.file(filePath);

    final isUrlLaunched = await launchUrl(uri);
    if (!isUrlLaunched) {
      throw Exception('Could not open file: $filePath');
    }
  }

  ///Revealing does not fully work on android and ios platorms.
  ///On those platforms corresponding file will be just openend.
  static Future<void> revealFile(String filePath) async {
    final file = File(filePath);
    final fileExists = await file.exists();

    if (!fileExists) {
      throw FileSystemException('File does not exist', filePath);
    }

    final folderPath = file.parent.path;

    if (Platform.isWindows) {
      await Process.run('explorer', ['/select,', filePath]);
    } else if (Platform.isMacOS) {
      await Process.run('open', ['-R', filePath]);
    } else if (Platform.isLinux) {
      final folderPath = File(filePath).parent.path;

      final fileManagers = [
        ['nautilus', '--select', filePath],
        ['dolphin', '--select', filePath],
        ['nemo', folderPath],
        ['xdg-open', folderPath],
      ];

      for (final command in fileManagers) {
        try {
          final result = await Process.run(command[0], command.sublist(1));
          if (result.exitCode == 0) return;
        } catch (_) {}
      }

      throw Exception('Could not open file manager on Linux.');
    } else if (Platform.isAndroid || Platform.isIOS) {
      final uri = Uri.directory(folderPath);
      final isUrlLaunched = await launchUrl(uri);

      if (!isUrlLaunched) {
        throw Exception('Could not open file: $filePath');
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
