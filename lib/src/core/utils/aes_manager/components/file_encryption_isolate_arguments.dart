import 'dart:isolate';
import 'dart:typed_data';

enum FileEncryptionCommand {
  pause,
  resume,
  cancel,
}

class FileEncryptionIsolateArguments {
  final bool isEncryption;
  final String inputPath;
  final String outputPath;
  final Uint8List key;

  final SendPort progressSendPort;
  final SendPort commandPortSendPort;

  FileEncryptionIsolateArguments({
    required this.isEncryption,
    required this.inputPath,
    required this.outputPath,
    required this.key,
    required this.progressSendPort,
    required this.commandPortSendPort,
  });
}
