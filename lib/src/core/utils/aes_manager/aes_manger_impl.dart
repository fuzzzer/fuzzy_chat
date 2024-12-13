part of 'aes_manager.dart';

class _AESManagerImpl {
  static const _nonceByteLength = 12;
  static const _keyByteLength = 32;
  static const _macSize = 128;
  static const _defaultChunkSize = 64 * 1024; // 64KB

  static Uint8List generateKey() {
    return generateRandomSecureBytes(_keyByteLength);
  }

  static Uint8List syncEncrypt(Uint8List bytes, Uint8List key) {
    final nonce = generateRandomSecureBytes(_nonceByteLength);
    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);
    final encryptCipher = _initializeCipher(
      isForEncryption: true,
      key: ephemeralKey,
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
      key: ephemeralKey,
      nonce: nonce,
    );
    return decryptCipher.process(ciphertext);
  }

  static Stream<FileProcessingProgress> encryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async* {
    final inputFile = File(inputPath);
    final outputFile = File(outputPath);

    final totalFileSize = await inputFile.length();
    var processedPart = 0.0;

    final nonce = generateRandomSecureBytes(_nonceByteLength);
    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);

    final encryptCipher = _initializeCipher(
      isForEncryption: true,
      key: ephemeralKey,
      nonce: nonce,
    );

    IOSink? outputSink;
    StreamSubscription<List<int>>? subscription;
    final controller = StreamController<FileProcessingProgress>();

    try {
      outputSink = outputFile.openWrite();
      outputSink.add(nonce);

      final inputStream = inputFile.openRead();
      subscription = inputStream.listen(
        (chunk) {
          final encryptedChunk = Uint8List(encryptCipher.getOutputSize(chunk.length));
          final processedLength = encryptCipher.processBytes(
            Uint8List.fromList(chunk),
            0,
            chunk.length,
            encryptedChunk,
            0,
          );
          outputSink!.add(encryptedChunk.sublist(0, processedLength));

          processedPart += chunk.length;
          final progress = (processedPart / totalFileSize).clamp(0.0, 1.0);
          controller.add(FileProcessingProgress(progress: progress));
        },
        onDone: () {
          final finalChunk = Uint8List(encryptCipher.getOutputSize(0));
          final finalLength = encryptCipher.doFinal(finalChunk, 0);
          if (finalLength > 0) {
            outputSink!.add(finalChunk.sublist(0, finalLength));
          }
          controller.add(FileProcessingProgress.completed());
        },
        onError: (dynamic e) => _handleError(
          e: e,
          processed: processedPart,
          totalCiphertextSize: totalFileSize,
          controller: controller,
          cancel: () => subscription?.cancel(),
        ),
        cancelOnError: true,
      );

      yield* controller.stream;
    } finally {
      await subscription?.cancel();
      await outputSink?.close();
      await controller.close();
    }
  }

  static Stream<FileProcessingProgress> decryptFile({
    required String inputPath,
    required String outputPath,
    required Uint8List key,
  }) async* {
    final inputFile = File(inputPath);
    final outputFile = File(outputPath);

    final totalSize = await inputFile.length();
    if (totalSize < _nonceByteLength) {
      throw ArgumentError('Encrypted file too short to contain a nonce.');
    }

    var processedPart = 0.0;

    final raf = await inputFile.open();
    final nonce = await _readNonce(raf);
    final ephemeralKey = _deriveEphemeralKey(mainKey: key, nonce: nonce);

    final decryptCipher = _initializeCipher(
      isForEncryption: false,
      key: ephemeralKey,
      nonce: nonce,
    );

    IOSink? outputSink;
    StreamSubscription<List<int>>? subscription;
    final controller = StreamController<FileProcessingProgress>();

    try {
      outputSink = outputFile.openWrite();
      final ciphertextSize = totalSize - _nonceByteLength;
      final inputStream = raf.readStream(chunkSize: _defaultChunkSize);

      subscription = inputStream.listen(
        (chunk) {
          final decryptedChunk = Uint8List(decryptCipher.getOutputSize(chunk.length));
          final processedLength = decryptCipher.processBytes(
            Uint8List.fromList(chunk),
            0,
            chunk.length,
            decryptedChunk,
            0,
          );
          outputSink!.add(decryptedChunk.sublist(0, processedLength));

          processedPart += chunk.length;
          final progress = (processedPart / ciphertextSize).clamp(0.0, 1.0);
          controller.add(FileProcessingProgress(progress: progress));
        },
        onDone: () {
          final finalChunk = Uint8List(decryptCipher.getOutputSize(0));
          final finalLength = decryptCipher.doFinal(finalChunk, 0);
          if (finalLength > 0) {
            outputSink!.add(finalChunk.sublist(0, finalLength));
          }
          controller.add(FileProcessingProgress.completed());
        },
        onError: (dynamic e) => _handleError(
          e: e,
          processed: processedPart,
          totalCiphertextSize: ciphertextSize,
          controller: controller,
          cancel: () => subscription?.cancel(),
        ),
        cancelOnError: true,
      );

      yield* controller.stream;
    } finally {
      await subscription?.cancel();
      await raf.close();
      await outputSink?.close();
      await controller.close();
    }
  }

  static GCMBlockCipher _initializeCipher({
    required bool isForEncryption,
    required Uint8List key,
    required Uint8List nonce,
  }) {
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(
      isForEncryption,
      AEADParameters(
        KeyParameter(key),
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
    required void Function() cancel,
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

extension _RandomAccessFileExtensions on RandomAccessFile {
  Stream<List<int>> readStream({required int chunkSize}) async* {
    while (true) {
      final buffer = Uint8List(chunkSize);
      final bytesRead = await readInto(buffer, 0, chunkSize);
      if (bytesRead <= 0) break;
      yield buffer.sublist(0, bytesRead);
    }
  }
}
