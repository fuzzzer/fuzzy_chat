part of 'custom_file_processing_cubit.dart';

class CustomFileProcessingState {
  final double progress; // value between 0 and 1
  final FileProcessingData? currentProcessingFile;
  final List<FileProcessingData> toBeProcessedFiles;
  final List<FileProcessingData> processedFiles;

  List<FileProcessingData> getToBeProcessedFilesByChatId(String chatId) {
    return toBeProcessedFiles.where((tbpf) => tbpf.chatId == chatId).toList();
  }

  List<FileProcessingData> getProcessedFilesByChatId(String chatId) {
    return processedFiles.where((pf) => pf.chatId == chatId).toList();
  }

  const CustomFileProcessingState({
    this.progress = 0.0,
    this.currentProcessingFile,
    this.toBeProcessedFiles = const [],
    this.processedFiles = const [],
  });

  CustomFileProcessingState copyWith({
    double? progress,
    FileProcessingData? currentProcessingFile,
    List<FileProcessingData>? toBeProcessedFiles,
    List<FileProcessingData>? processedFiles,
  }) {
    return CustomFileProcessingState(
      progress: progress ?? this.progress,
      currentProcessingFile:
          currentProcessingFile ?? this.currentProcessingFile,
      toBeProcessedFiles: toBeProcessedFiles ?? this.toBeProcessedFiles,
      processedFiles: processedFiles ?? this.processedFiles,
    );
  }

  CustomFileProcessingState copyWithCleanProgress() {
    return CustomFileProcessingState(
      toBeProcessedFiles: toBeProcessedFiles,
      processedFiles: processedFiles,
    );
  }

  @override
  String toString() {
    return 'CustomFileProcessingState(progress: $progress, currentProcessingFile: $currentProcessingFile, toBeProcessedFiles: $toBeProcessedFiles, processedFiles: $processedFiles)';
  }
}
