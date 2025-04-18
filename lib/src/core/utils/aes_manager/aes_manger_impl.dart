part of 'aes_manager.dart';

class _AESManagerImpl {
  static const int _nonceByteLength = 12;
  static const int _saltByteLength = 24;
  static const int _keyByteLength = 32;
  static const int _macSize = 128;

  static Uint8List generateKey() {
    return generateRandomSecureBytes(_keyByteLength);
  }

  static Uint8List syncEncrypt(Uint8List bytes, Uint8List key) {
    final salt = generateRandomSecureBytes(_saltByteLength);
    final nonce = generateRandomSecureBytes(_nonceByteLength);

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, salt: salt);
    final encryptCipher = _initializeCipher(
      isForEncryption: true,
      ephemeralKey: ephemeralKey,
      nonce: nonce,
    );

    final encryptedBytes = encryptCipher.process(bytes);

    return Uint8List.fromList(salt + nonce + encryptedBytes);
  }

  static Uint8List syncDecrypt(Uint8List encryptedBytes, Uint8List key) {
    if (encryptedBytes.length < _nonceByteLength) {
      throw ArgumentError('Ciphertext too short, no room for nonce.');
    }

    final salt = encryptedBytes.sublist(0, _saltByteLength);
    final nonce = encryptedBytes.sublist(_saltByteLength, _saltByteLength + _nonceByteLength);
    final ciphertext = encryptedBytes.sublist(_saltByteLength + _nonceByteLength);

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, salt: salt);
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
    final salt = generateRandomSecureBytes(_saltByteLength);
    final nonce = generateRandomSecureBytes(_nonceByteLength);

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, salt: salt);
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
      salt: salt,
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

    final (salt, nonce) = await _readSaltAndNonce(randomAccessFile);
    await randomAccessFile.close();

    final ephemeralKey = _deriveEphemeralKey(mainKey: key, salt: salt);

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
      salt: salt,
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
    required Uint8List salt,
  }) {
    final hkdf = HKDFKeyDerivator(SHA256Digest())
      ..init(
        HkdfParameters(
          mainKey,
          _keyByteLength,
          salt,
          fuzzVersionInfo,
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
    required Uint8List salt,
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
      salt: salt,
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
    required Uint8List salt,
    required GCMBlockCipher cipher,
    required StreamController<FileProcessingProgress> controller,
    required bool Function() isPaused,
    required bool Function() isCancelled,
  }) async {
    IOSink? outputSink;
    double processedInputSize = 0;
    double progress = 0;
    final inputFile = File(inputPath);
    final outputFile = File(outputPath);
    int? totalInputFileSize;

    try {
      totalInputFileSize = await inputFile.length();

      outputSink = outputFile.openWrite();

      final int totalSizeToBeProcessed;
      final Stream<List<int>> inputStream;

      if (isEncryption) {
        //Input is file to be encrypted and before encrypted text writing the nonce and salt
        outputSink.add(salt);
        outputSink.add(nonce);

        //Input is file so it should be processed fully
        totalSizeToBeProcessed = totalInputFileSize;
        inputStream = inputFile.openRead();
      } else {
        // Input is encrypted file and to get full text size that needs to be decrypted skip the nonce and salt.
        totalSizeToBeProcessed = totalInputFileSize - _saltByteLength - _nonceByteLength;
        inputStream = inputFile.openRead(_saltByteLength + _nonceByteLength);
      }

      await _processChunks(
        inputStream: inputStream,
        cipher: cipher,
        outputSink: outputSink,
        isPaused: isPaused,
        isCancelled: isCancelled,
        onInputChunkProcessed: (processedSize) {
          processedInputSize += processedSize;
          progress = (processedInputSize / totalSizeToBeProcessed).clamp(0.0, 1.0);
          controller.add(FileProcessingProgress(progress: progress));
        },
      );
    } catch (e) {
      logger.e('ERROR: while processing file $e');
      await _handleError(
        e: e,
        controller: controller,
        outputFile: outputFile,
        processedSize: processedInputSize,
        totalInputFileSize: totalInputFileSize ?? 0,
      );
    } finally {
      await outputSink?.flush();
      await outputSink?.close();

      controller.add(FileProcessingProgress.completed());

      await controller.close();
    }
  }

  static Future<void> _processChunks({
    required Stream<List<int>> inputStream,
    required GCMBlockCipher cipher,
    required IOSink outputSink,
    required bool Function() isPaused,
    required bool Function() isCancelled,
    required void Function(int processedChunkLength) onInputChunkProcessed,
  }) async {
    await for (final chunk in inputStream) {
      if (isCancelled()) {
        break;
      }

      while (isPaused()) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (isCancelled()) {
          break;
        }
      }

      if (isCancelled()) {
        break;
      }

      final chunkBytes = Uint8List.fromList(chunk);
      final outputSize = cipher.getOutputSize(chunkBytes.length) + (cipher.forEncryption ? 0 : cipher.blockSize);
      final outputBuffer = Uint8List(outputSize);

      final processedLength = cipher.processBytes(
        chunkBytes,
        0,
        chunkBytes.length,
        outputBuffer,
        0,
      );

      if (processedLength > outputSize) {
        throw StateError('Cipher produced more bytes than even over-allocated size.');
      }

      if (processedLength > 0) {
        final toWrite = outputBuffer.sublist(0, processedLength);
        outputSink.add(toWrite);
      }

      onInputChunkProcessed(chunkBytes.length);
    }

    if (!isCancelled()) {
      final leftoverBytes = cipher.remainingInput.length;
      final finalOutputSize =
          cipher.getOutputSize(leftoverBytes) + cipher.blockSize + (cipher.forEncryption ? cipher.macSize : 0);
      final finalBuffer = Uint8List(finalOutputSize);

      final finalLength = cipher.doFinal(finalBuffer, 0);

      if (finalLength > 0) {
        final toWrite = finalBuffer.sublist(0, finalLength);
        outputSink.add(toWrite);
      }
    }

    await outputSink.flush();
  }

  static Future<(Uint8List salt, Uint8List nonce)> _readSaltAndNonce(RandomAccessFile raf) async {
    const totalLength = _saltByteLength + _nonceByteLength;

    final saltAndNonceBuffer = Uint8List(totalLength);
    final bytesRead = await raf.readInto(saltAndNonceBuffer, 0, totalLength);
    if (bytesRead != totalLength) {
      throw ArgumentError('Could not read nonce from encrypted file.');
    }
    final salt = saltAndNonceBuffer.sublist(0, _saltByteLength);
    final nonce = saltAndNonceBuffer.sublist(_saltByteLength, totalLength);
    return (salt, nonce);
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
