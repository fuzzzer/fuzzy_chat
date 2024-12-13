part of 'aes_manager.dart';

class _AESManagerImpl {
  static const int _nonceByteLength = 12;
  static const int _keyByteLength = 32;
  static const int _macSize = 128;

  static Uint8List generateKey() {
    return generateRandomSecureBytes(_keyByteLength);
  }

  static Uint8List syncEncrypt(Uint8List bytes, Uint8List key) {
    final nonce = generateRandomSecureBytes(_nonceByteLength);
    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);
    final encryptCipher = _initializeCipher(
      isForEncryption: true,
      ephemeralKey: ephemeralKey,
      nonce: nonce,
    );
    final encryptedBytes = encryptCipher.process(bytes);
    return Uint8List.fromList(nonce + encryptedBytes);
  }

  static Uint8List syncDecrypt(Uint8List encryptedBytes, Uint8List key) {
    if (encryptedBytes.length < _nonceByteLength) {
      throw ArgumentError('Ciphertext too short, no room for nonce.');
    }

    final nonce = encryptedBytes.sublist(0, _nonceByteLength);
    final ciphertext = encryptedBytes.sublist(_nonceByteLength);
    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);
    final decryptCipher = _initializeCipher(
      isForEncryption: false,
      ephemeralKey: ephemeralKey,
      nonce: nonce,
    );
    return decryptCipher.process(ciphertext);
  }

  static FileProcessingHandler encryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) {
    final nonce = generateRandomSecureBytes(_nonceByteLength);

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);
    final cipher = _initializeCipher(
      isForEncryption: true,
      ephemeralKey: ephemeralKey,
      nonce: nonce,
    );

    return _processFile(
      inputPath: inputPath,
      outputPath: outputPath,
      isEncryption: true,
      cipher: cipher,
      nonce: nonce,
    );
  }

  static Future<FileProcessingHandler> decryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async {
    final inputFile = File(inputPath);
    final raf = await inputFile.open();
    final nonce = await _readNonce(raf);
    await raf.close();

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);
    final cipher = _initializeCipher(
      isForEncryption: false,
      ephemeralKey: ephemeralKey,
      nonce: nonce,
    );

    return _processFile(
      inputPath: inputPath,
      outputPath: outputPath,
      isEncryption: false,
      nonce: nonce,
      cipher: cipher,
    );
  }

  static FileProcessingHandler _processFile({
    required String inputPath,
    required String outputPath,
    required bool isEncryption,
    required Uint8List nonce,
    required GCMBlockCipher cipher,
  }) {
    final controller = StreamController<FileProcessingProgress>();
    bool isPaused = false;
    bool isCancelled = false;

    void pause() => isPaused = true;
    void resume() => isPaused = false;
    Future<void> cancel() async {
      isCancelled = true;
      controller.add(FileProcessingProgress.cancelled(currentProgress: 0));
      await controller.close();
    }

    _startFileProcessing(
      inputPath: inputPath,
      outputPath: outputPath,
      isEncryption: isEncryption,
      nonce: nonce,
      cipher: cipher,
      controller: controller,
      isPaused: () => isPaused,
      isCancelled: () => isCancelled,
    );

    return FileProcessingHandler(
      progressStream: controller.stream,
      pause: pause,
      resume: resume,
      cancel: cancel,
    );
  }

  static Future<void> _startFileProcessing({
    required String inputPath,
    required String outputPath,
    required bool isEncryption,
    required Uint8List nonce,
    required GCMBlockCipher cipher,
    required StreamController<FileProcessingProgress> controller,
    required bool Function() isPaused,
    required bool Function() isCancelled,
  }) async {
    IOSink? outputSink;
    StreamSubscription<List<int>>? subscription;
    double processedSize = 0;

    try {
      final inputFile = File(inputPath);
      final outputFile = File(outputPath);
      final totalInputFileSize = await inputFile.length();

      outputSink = outputFile.openWrite();

      final int adjustedTotalSize;
      final Stream<List<int>> inputStream;

      if (isEncryption) {
        //in case of encryption we start writing with nonce (so that we have it later, when decrypting)
        outputSink.add(nonce);
        adjustedTotalSize = totalInputFileSize;
        inputStream = inputFile.openRead();
      } else {
        //in case of decription we start reading content after nonce
        adjustedTotalSize = totalInputFileSize - _nonceByteLength;
        inputStream = inputFile.openRead(_nonceByteLength);
      }

      subscription = _startProcessing(
        inputStream: inputStream,
        cipher: cipher,
        outputSink: outputSink,
        controller: controller,
        isPaused: isPaused,
        isCancelled: isCancelled,
        onChunkProcessed: (processedChunkLength) {
          processedSize += processedChunkLength;
          final progress = (processedSize / adjustedTotalSize).clamp(0.0, 1.0);
          controller.add(FileProcessingProgress(progress: progress));
        },
      );
    } catch (e) {
      _handleError(
        e: e,
        processed: processedSize,
        totalCiphertextSize: 0,
        controller: controller,
        cancel: () async {
          await subscription?.cancel();
          await outputSink?.close();
        },
      );
    }
  }

  static StreamSubscription<List<int>> _startProcessing({
    required Stream<List<int>> inputStream,
    required GCMBlockCipher cipher,
    required IOSink? outputSink,
    required StreamController<FileProcessingProgress> controller,
    required bool Function() isPaused,
    required bool Function() isCancelled,
    required void Function(int processedChunkLength) onChunkProcessed,
  }) {
    return inputStream.listen(
      (chunk) async {
        if (isCancelled()) return;
        if (isPaused()) {
          await Future.doWhile(() async {
            await Future.delayed(const Duration(milliseconds: 100));
            return isPaused();
          });
        }

        final outputBuffer = Uint8List(cipher.getOutputSize(chunk.length));
        final processedLength = cipher.processBytes(
          Uint8List.fromList(chunk),
          0,
          chunk.length,
          outputBuffer,
          0,
        );
        outputSink!.add(outputBuffer.sublist(0, processedLength));
        onChunkProcessed(chunk.length);
      },
      onDone: () {
        final finalChunk = Uint8List(cipher.getOutputSize(0));
        final finalLength = cipher.doFinal(finalChunk, 0);
        if (finalLength > 0) {
          outputSink!.add(finalChunk.sublist(0, finalLength));
        }
        controller.add(FileProcessingProgress.completed());
      },
      onError: (dynamic e) {
        controller.add(
          FileProcessingProgress.failed(
            message: 'Error during processing: $e',
            currentProgress: 0,
          ),
        );
      },
      cancelOnError: true,
    );
  }

  static GCMBlockCipher _initializeCipher({
    required bool isForEncryption,
    required Uint8List ephemeralKey,
    required Uint8List nonce,
  }) {
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      isForEncryption,
      AEADParameters(
        KeyParameter(ephemeralKey),
        _macSize,
        nonce,
        Uint8List(0),
      ),
    );
    return cipher;
  }

  static Uint8List _deriveEphemeralKey({
    required Uint8List mainKey,
    required Uint8List nonce,
  }) {
    final hkdf = HKDFKeyDerivator(SHA256Digest())
      ..init(
        HkdfParameters(
          mainKey,
          _keyByteLength,
          null,
          nonce,
        ),
      );

    final derived = Uint8List(_keyByteLength);
    hkdf.deriveKey(null, 0, derived, 0);
    return derived;
  }

  static Future<Uint8List> _readNonce(RandomAccessFile raf) async {
    final nonceBuffer = Uint8List(_nonceByteLength);
    final bytesRead = await raf.readInto(nonceBuffer, 0, _nonceByteLength);
    if (bytesRead != _nonceByteLength) {
      throw ArgumentError('Could not read nonce from encrypted file.');
    }
    return nonceBuffer;
  }

  static void _handleError({
    required dynamic e,
    required double processed,
    required int totalCiphertextSize,
    required StreamController<FileProcessingProgress> controller,
    required Future<void> Function() cancel,
  }) {
    controller.add(
      FileProcessingProgress.failed(
        message: 'Error while processing file: $e',
        currentProgress: (processed / totalCiphertextSize).clamp(0.0, 1.0),
      ),
    );
    cancel();
  }
}
