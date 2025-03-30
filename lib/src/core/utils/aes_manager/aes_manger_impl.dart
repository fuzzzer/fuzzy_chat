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
        inputStream: inputStream,
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
      // await outputSink?.flush();
      // await outputSink?.close();
      // await controller.close();
    }
  }

  static Future<void> _processChunks({
    required Stream<List<int>> inputStream,
    required GCMBlockCipher cipher,
    required IOSink outputSink,
    required bool Function() isPaused,
    required bool Function() isCancelled,
    required void Function(int processedChunkLength) onChunkProcessed,
  }) async {
    print('[DEBUG] GCM cipher mode: ${cipher.forEncryption ? "ENCRYPTION" : "DECRYPTION"}');
    print('[DEBUG] GCM blockSize: ${cipher.blockSize}, macSize: ${cipher.macSize}');

    await for (final chunk in inputStream) {
      if (isCancelled()) {
        print('[DEBUG] Operation cancelled before next chunk.');
        break;
      }

      while (isPaused()) {
        print('[DEBUG] Processing paused...');
        await Future.delayed(const Duration(milliseconds: 100));
        if (isCancelled()) {
          print('[DEBUG] Operation cancelled while paused.');
          break;
        }
      }

      if (isCancelled()) {
        print('[DEBUG] Operation cancelled after pause check.');
        break;
      }

      final chunkBytes = Uint8List.fromList(chunk);
      print('[DEBUG] Incoming chunk length: ${chunkBytes.length}');

      // Over-allocate the output buffer by one block size to avoid RangeError
      final normalOutSize = cipher.getOutputSize(chunkBytes.length);
      print('[DEBUG] normal getOutputSize for chunk: $normalOutSize');

      final overAllocatedOutSize = normalOutSize + cipher.blockSize;
      print('[DEBUG] overAllocatedOutSize: $overAllocatedOutSize');

      final outputBuffer = Uint8List(overAllocatedOutSize);
      print('[DEBUG] outputBuffer.length: ${outputBuffer.length}');

      // Process
      final processedLength = cipher.processBytes(
        chunkBytes, // input data
        0, // input offset
        chunkBytes.length, // length of data to process
        outputBuffer, // output buffer
        0, // output offset
      );

      print('[DEBUG] processedLength: $processedLength');

      if (processedLength > overAllocatedOutSize) {
        print('[ERROR] processBytes returned $processedLength which is > $overAllocatedOutSize');
        // You can throw or handle error
        throw StateError('Cipher produced more bytes than even over-allocated size.');
      }

      if (processedLength > 0) {
        final toWrite = outputBuffer.sublist(0, processedLength);
        print('[DEBUG] writing processed bytes to sink: length ${toWrite.length}');
        outputSink.add(toWrite);
        onChunkProcessed(processedLength);
      }
    }

    if (!isCancelled()) {
      final leftoverBytes = cipher.remainingInput.length;
      print('[DEBUG] leftoverBytes in cipher: $leftoverBytes');

      final finalOutSize = cipher.getOutputSize(leftoverBytes);
      print('[DEBUG] finalOutSize (for doFinal): $finalOutSize');

      // Over-allocate again for final
      final overAllocatedFinalSize = finalOutSize + cipher.blockSize;
      final finalBuffer = Uint8List(overAllocatedFinalSize);
      print('[DEBUG] finalBuffer.length (overallocated): ${finalBuffer.length}');

      final finalLength = cipher.doFinal(finalBuffer, 0);
      print('[DEBUG] finalLength returned by doFinal: $finalLength');

      if (finalLength > overAllocatedFinalSize) {
        print('[ERROR] doFinal returned more bytes than the overallocated buffer!');
        throw StateError('Cipher produced more bytes than over-allocated final buffer.');
      }

      if (finalLength > 0) {
        final toWrite = finalBuffer.sublist(0, finalLength);
        print('[DEBUG] writing final bytes to sink: length ${toWrite.length}');
        outputSink.add(toWrite);
        onChunkProcessed(finalLength);
      }
    } else {
      print('[DEBUG] Skipping doFinal due to cancellation.');
    }

    await outputSink.flush();
    print('[DEBUG] Finished processing (or cancelled).');
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
