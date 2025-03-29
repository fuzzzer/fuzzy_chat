import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

export 'components/components.dart';

// ignore_for_file: avoid_redundant_argument_values

part 'file_processing_state.dart';

class FileProcessingCubit<ActualProcessingOption extends FileProcessingOption> extends Cubit<FileProcessingState> {
  final KeyStorageRepository keyStorageRepository;
  final ActualProcessingOption processingOption;

  FileProcessingCubit({
    required this.keyStorageRepository,
    required this.processingOption,
  }) : super(const FileProcessingState());

  StreamSubscription<FileProcessingProgress>? _progressSubscription;
  FileProcessingHandler? _activeFileProcessingHandler;

  static const progressPostingThrottleDuration = Duration(milliseconds: 100);
  Timer? _throttleTimer;
  double? _pendingProgress;

  void markProcessedFilesAsReadAndClear({
    required List<FileProcessingData> readProcessedFiles,
  }) {
    final updatedProcessedFilesList = state.processedFiles
        .where(
          (processedFile) => !readProcessedFiles.contains(processedFile),
        )
        .toList();

    emit(
      state.copyWith(
        processedFiles: updatedProcessedFilesList,
      ),
    );
  }

  void addFilesToProcess({
    required String chatId,
    required List<String> filePaths,
  }) {
    final now = DateTime.now();

    final newFilesToBeProcessed = filePaths.map(
      (path) => FileProcessingData(
        chatId: chatId,
        inputFilePath: path,
        encryptionStartTime: now,
        status: FileProcessingStatus.pending,
      ),
    );

    final updatedQueue = [
      ...state.toBeProcessedFiles,
      ...newFilesToBeProcessed,
    ];

    emit(state.copyWith(toBeProcessedFiles: updatedQueue));

    if (state.currentProcessingFile == null) {
      _startNextFileProcessing();
    }
  }

  void _startNextFileProcessing() {
    final toBeProcessedFiles = state.toBeProcessedFiles;

    if (toBeProcessedFiles.isEmpty) {
      emit(state.copyWithCleanProgress());
      return;
    }

    logger.i('FILE PROCESSING: To be processed files: $toBeProcessedFiles');

    final nextFileData = toBeProcessedFiles.first.copyWith(
      status: FileProcessingStatus.inProgress,
      progress: 0,
    );

    final updatedToBeProcessedFiles = [
      nextFileData,
      ...toBeProcessedFiles.skip(1),
    ];

    emit(
      state.copyWith(
        toBeProcessedFiles: updatedToBeProcessedFiles,
        currentProcessingFile: nextFileData.inputFilePath,
        progress: 0,
      ),
    );

    _processFile(fileData: nextFileData);
  }

  Future<void> _processFile({
    required FileProcessingData fileData,
  }) async {
    try {
      //TODO refine output path handling and set up correct output paths not same directory as input
      String outputPath = '';

      FileProcessingHandler handler;

      final symmetricKey = await keyStorageRepository.getSymmetricKey(fileData.chatId);

      if (symmetricKey == null) {
        throw Exception('Symmetric key not found');
      }

      if (processingOption is FileEncryptionOption) {
        outputPath = '${fileData.inputFilePath}.$fuzzedFileIdentificator';

        handler = await AESManager.encryptFile(
          inputPath: fileData.inputFilePath,
          outputPath: outputPath,
          key: symmetricKey,
        );
      } else if (processingOption is FileDecryptionOption) {
        outputPath = fileData.inputFilePath.replaceFirst(RegExp('.$fuzzedFileIdentificator'), '');

        handler = await AESManager.decryptFile(
          inputPath: fileData.inputFilePath,
          outputPath: outputPath,
          key: symmetricKey,
        );
      } else {
        throw UnimplementedError('Unsupported FileProcessingOption: ${processingOption.runtimeType}');
      }

      _activeFileProcessingHandler = handler;

      _progressSubscription = handler.progressStream.listen(
        (event) => _onProgress(
          event: event,
          fileData: fileData,
          outputPath: outputPath,
        ),
      );

      logger.i('FILE PROCESSING: _progressSubscription set up correctly');
    } catch (error) {
      logger.i('FILE PROCESSING: file processing failed: $error');

      _markFileAsFinished(
        fileData: fileData,
        status: FileProcessingStatus.failed,
        outputFilePath: null,
      );
      _goToNextFileProcessing();
    }
  }

  void _onProgress({
    required FileProcessingProgress event,
    required FileProcessingData fileData,
    required String outputPath,
  }) {
    if (event.isCancelled) {
      _resetThrottle();
      _markFileAsFinished(
        fileData: fileData,
        status: FileProcessingStatus.canceled,
        outputFilePath: null,
        progress: event.progress,
      );
      _goToNextFileProcessing();
      logger.i('FILE PROCESSING: Marked as isCancelled $state');
      return;
    }

    if (event.isComplete) {
      _resetThrottle();
      _markFileAsFinished(
        fileData: fileData,
        status: FileProcessingStatus.completed,
        outputFilePath: outputPath,
        progress: 1,
      );
      _goToNextFileProcessing();
      logger.i('FILE PROCESSING: Marked as isComplete $state');
      return;
    }

    _handleThrottledProgress(
      fileData: fileData,
      progress: event.progress,
    );
  }

  void _resetThrottle() {
    _throttleTimer?.cancel();
    _throttleTimer = null;
    _pendingProgress = null;
  }

  void _handleThrottledProgress({
    required FileProcessingData fileData,
    required double progress,
  }) {
    if (_throttleTimer != null) {
      _pendingProgress = progress;
      return;
    }

    _updateFileStatus(
      fileData: fileData,
      newStatus: FileProcessingStatus.inProgress,
      newProgress: progress,
    );

    //Timer callback will collect all acumulated _pendingProgress which was saved while progress was being detected when timer was ON.
    _throttleTimer = Timer(progressPostingThrottleDuration, () {
      if (_pendingProgress != null) {
        _updateFileStatus(
          fileData: fileData,
          newStatus: FileProcessingStatus.inProgress,
          newProgress: _pendingProgress!,
        );
        _pendingProgress = null;
      }
      _throttleTimer = null;
    });
  }

  void _markFileAsFinished({
    required FileProcessingData fileData,
    required FileProcessingStatus status,
    required String? outputFilePath,
    double? progress,
  }) {
    final updatedFile = fileData.copyWith(
      status: status,
      outputFilePath: outputFilePath,
      progress: progress ?? fileData.progress,
      isProcessed: true,
    );

    final updatedState = _removeFromQueueAndAddToProcessed(fileProcessingData: updatedFile);

    final isActive = updatedFile.inputFilePath == state.currentProcessingFile;

    emit(
      updatedState.copyWith(
        currentProcessingFile: isActive ? null : state.currentProcessingFile,
        progress: isActive ? 0.0 : state.progress,
      ),
    );
  }

  FileProcessingState _removeFromQueueAndAddToProcessed({
    required FileProcessingData fileProcessingData,
  }) {
    final newToBeProcessed =
        state.toBeProcessedFiles.where((e) => e.inputFilePath != fileProcessingData.inputFilePath).toList();
    final newProcessed = [...state.processedFiles, fileProcessingData];

    return state.copyWith(
      toBeProcessedFiles: newToBeProcessed,
      processedFiles: newProcessed,
    );
  }

  void _goToNextFileProcessing() {
    _cleanCurrentFileProcessingResources();
    _startNextFileProcessing();
  }

  void _cleanCurrentFileProcessingResources() {
    _progressSubscription?.cancel();
    _progressSubscription = null;
    _activeFileProcessingHandler = null;
  }

  void _updateFileStatus({
    required FileProcessingData fileData,
    required FileProcessingStatus newStatus,
    required double newProgress,
  }) {
    final updatedToBeProcessedFiles = state.toBeProcessedFiles.map((item) {
      if (item.inputFilePath == fileData.inputFilePath) {
        return item.copyWith(
          status: newStatus,
          progress: newProgress,
        );
      }
      return item;
    }).toList();

    final isActive = fileData.inputFilePath == state.currentProcessingFile;

    emit(
      state.copyWith(
        toBeProcessedFiles: updatedToBeProcessedFiles,
        progress: isActive ? newProgress : state.progress,
      ),
    );
  }

  void pauseFile() => _activeFileProcessingHandler?.pause();

  void resumeFile() => _activeFileProcessingHandler?.resume();

  void cancelFile() => _activeFileProcessingHandler?.cancel();

  @override
  Future<void> close() {
    _progressSubscription?.cancel();
    _activeFileProcessingHandler = null;
    return super.close();
  }
}
