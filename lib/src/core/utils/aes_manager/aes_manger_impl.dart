part of 'aes_manager.dart';

class _AESManagerImpl {
  static const int _nonceByteLength = 12;
  static const int _keyByteLength = 32;
  static const int _macSize = 128;
  static const int _aesBlockSize = 16;

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
    final randomAccessFile = await inputFile.open();

    final nonce = await _readNonce(randomAccessFile);
    await randomAccessFile.close();

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
      controller.add(FileProcessingProgress.cancelled());
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
    double processedSize = 0;
    final inputFile = File(inputPath);
    final outputFile = File(outputPath);
    int? totalInputFileSize;

    try {
      totalInputFileSize = await inputFile.length();

      outputSink = outputFile.openWrite();

      final int adjustedTotalSize;
      final Stream<List<int>> inputStream;

      if (isEncryption) {
        // For encryption, write the nonce first.
        outputSink.add(nonce);
        adjustedTotalSize = totalInputFileSize;
        inputStream = inputFile.openRead();
      } else {
        // For decryption, skip the nonce.
        adjustedTotalSize = totalInputFileSize - _nonceByteLength;
        inputStream = inputFile.openRead(_nonceByteLength);
      }

      await _processChunks(
        isEncryption: isEncryption,
        inputStream: inputStream,
        adjustedTotalSize: adjustedTotalSize,
        cipher: cipher,
        outputSink: outputSink,
        isPaused: isPaused,
        isCancelled: isCancelled,
        onChunkProcessed: (processedChunkLength) {
          processedSize += processedChunkLength;
          final progress = (processedSize / adjustedTotalSize).clamp(0.0, 1.0);
          controller.add(FileProcessingProgress(progress: progress));

          if (progress == 1) {
            controller.add(FileProcessingProgress.completed());
          }
        },
      );
    } catch (e) {
      logger.e('ERROR: while processing file $e');
      await _handleError(
        e: e,
        controller: controller,
        outputFile: outputFile,
        processedSize: processedSize,
        totalInputFileSize: totalInputFileSize ?? 0,
      );
    } finally {
      await outputSink?.close();
      await controller.close();
    }
  }

  static Future<void> _processChunks({
    required bool isEncryption,
    required Stream<List<int>> inputStream,
    required int adjustedTotalSize,
    required GCMBlockCipher cipher,
    required IOSink outputSink,
    required bool Function() isPaused,
    required bool Function() isCancelled,
    required void Function(int processedChunkLength) onChunkProcessed,
  }) async {
    int processedInputSize = 0;

    await for (final chunk in inputStream) {
      if (isCancelled()) break;
      while (isPaused()) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final chunkBytes = Uint8List.fromList(chunk);
      final int outputLength;

      // Using getOutputSize for encryption to account for overhead; decryption requires exact input size.
      if (isEncryption) {
        outputLength = cipher.getOutputSize(chunkBytes.length);
      } else {
        final isLastChunk = (processedInputSize + chunkBytes.length) == adjustedTotalSize;
        outputLength = chunkBytes.length + (isLastChunk ? _aesBlockSize : 0);
      }

      final outputBuffer = Uint8List(outputLength);
      final processedLength = cipher.processBytes(
        chunkBytes,
        0,
        chunkBytes.length,
        outputBuffer,
        0,
      );
      outputSink.add(outputBuffer.sublist(0, processedLength));
      onChunkProcessed(chunk.length);
      processedInputSize += chunkBytes.length;
    }

    final finalChunk = Uint8List(cipher.getOutputSize(0) + _aesBlockSize);
    final finalLength = cipher.doFinal(finalChunk, 0);
    if (finalLength > 0) {
      outputSink.add(finalChunk.sublist(0, finalLength));
      onChunkProcessed(finalLength);
    }
  }

  static Future<Uint8List> _readNonce(RandomAccessFile raf) async {
    final nonceBuffer = Uint8List(_nonceByteLength);
    final bytesRead = await raf.readInto(nonceBuffer, 0, _nonceByteLength);
    if (bytesRead != _nonceByteLength) {
      throw ArgumentError('Could not read nonce from encrypted file.');
    }
    return nonceBuffer;
  }

  static Future<void> _handleError({
    required dynamic e,
    required StreamController<FileProcessingProgress> controller,
    required File? outputFile,
    required double processedSize,
    required int totalInputFileSize,
  }) async {
    controller.add(
      FileProcessingProgress.failed(
        message: 'Error while processing: $e',
        currentProgress: (processedSize / totalInputFileSize).clamp(0.0, 1.0),
      ),
    );

    //Attempting to delete the output file if an error occurs, in the future in continuation of encrytion is introduced, maybe do not delete the generated file
    if (outputFile != null && (await outputFile.exists())) {
      await outputFile.delete();
    }
  }
}
