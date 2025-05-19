import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:pointycastle/export.dart';

export 'components/components.dart';

part 'aes_service_impl.dart';

class AESService {
  static Future<Uint8List> encrypt(Uint8List bytes, Uint8List key) async =>
      Isolate.run(() => _AESServiceImpl.syncEncrypt(bytes, key));

  static Future<Uint8List> decrypt(Uint8List encryptedBytes, Uint8List key) async =>
      Isolate.run(() => _AESServiceImpl.syncDecrypt(encryptedBytes, key));

  static Future<String> encryptText(String text, Uint8List key) async {
    final decryptedTextBytes = utf8.encode(text);
    final encryptedTextBytes = await encrypt(decryptedTextBytes, key);
    return base64Encode(encryptedTextBytes);
  }

  static Future<String> decryptText(String base64EncryptedText, Uint8List key) async {
    final encryptedTextBytes = base64Decode(base64EncryptedText);
    final decryptedTextBytes = await decrypt(encryptedTextBytes, key);
    return utf8.decode(decryptedTextBytes);
  }

  static Future<Uint8List> generateKey() async => Isolate.run(_AESServiceImpl.generateKey);

  static Future<FileProcessingHandler> encryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async {
    final progressReceivePort = ReceivePort();
    final commandPortReceivePort = ReceivePort();

    final controller = StreamController<FileProcessingProgress>();

    final args = FileEncryptionIsolateArguments(
      isEncryption: true,
      inputPath: inputPath,
      outputPath: outputPath,
      key: key,
      progressSendPort: progressReceivePort.sendPort,
      commandPortSendPort: commandPortReceivePort.sendPort,
    );

    final isolate = await Isolate.spawn(
      fileEncryptionIsolateEntry,
      args,
      debugName: 'FileEncryptionIsolate',
    );

    progressReceivePort.listen((message) {
      if (message is FileProcessingProgress) {
        controller.add(message);

        if (message.isComplete || message.isCancelled || message.errorMessage != null) {
          controller.close();
          isolate.kill(priority: Isolate.immediate);
        }
      }
    });

    SendPort? commandSendPort;
    commandPortReceivePort.listen((dynamic msg) {
      if (msg is SendPort) {
        commandSendPort = msg;
      }
    });

    void sendCommand(FileEncryptionCommand cmd) {
      commandSendPort?.send(cmd);
    }

    void pause() => sendCommand(FileEncryptionCommand.pause);
    void resume() => sendCommand(FileEncryptionCommand.resume);
    void cancel() => sendCommand(FileEncryptionCommand.cancel);

    return FileProcessingHandler(
      progressStream: controller.stream,
      pause: pause,
      resume: resume,
      cancel: cancel,
    );
  }

  static Future<FileProcessingHandler> decryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async {
    final progressReceivePort = ReceivePort();
    final commandPortReceivePort = ReceivePort();
    final controller = StreamController<FileProcessingProgress>();

    final args = FileEncryptionIsolateArguments(
      isEncryption: false,
      inputPath: inputPath,
      outputPath: outputPath,
      key: key,
      progressSendPort: progressReceivePort.sendPort,
      commandPortSendPort: commandPortReceivePort.sendPort,
    );

    final isolate = await Isolate.spawn(
      fileEncryptionIsolateEntry,
      args,
      debugName: 'FileDecryptionIsolate',
    );

    progressReceivePort.listen((message) {
      if (message is FileProcessingProgress) {
        controller.add(message);

        if (message.isComplete || message.isCancelled || message.errorMessage != null) {
          controller.close();
          isolate.kill(priority: Isolate.immediate);
        }
      }
    });

    SendPort? commandSendPort;
    commandPortReceivePort.listen((dynamic msg) {
      if (msg is SendPort) {
        commandSendPort = msg;
      }
    });

    void sendCommand(FileEncryptionCommand cmd) {
      commandSendPort?.send(cmd);
    }

    void pause() => sendCommand(FileEncryptionCommand.pause);
    void resume() => sendCommand(FileEncryptionCommand.resume);
    void cancel() => sendCommand(FileEncryptionCommand.cancel);

    return FileProcessingHandler(
      progressStream: controller.stream,
      pause: pause,
      resume: resume,
      cancel: cancel,
    );
  }
}

Future<void> fileEncryptionIsolateEntry(FileEncryptionIsolateArguments args) async {
  final commandReceivePort = ReceivePort();

  args.commandPortSendPort.send(commandReceivePort.sendPort);

  final handler = args.isEncryption
      ? _AESServiceImpl.encryptFile(
          inputPath: args.inputPath,
          outputPath: args.outputPath,
          key: args.key,
        )
      : await _AESServiceImpl.decryptFile(
          inputPath: args.inputPath,
          outputPath: args.outputPath,
          key: args.key,
        );

  final subscription = handler.progressStream.listen((progress) {
    args.progressSendPort.send(progress);
  });

  commandReceivePort.listen((message) {
    if (message is FileEncryptionCommand) {
      switch (message) {
        case FileEncryptionCommand.pause:
          handler.pause();
        case FileEncryptionCommand.resume:
          handler.resume();
        case FileEncryptionCommand.cancel:
          handler.cancel();
      }
    }
  });

  await subscription.asFuture<void>();

  await subscription.cancel();
}
