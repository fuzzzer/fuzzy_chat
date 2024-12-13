class FileProcessingProgress {
  final double progress; // value between 0 and 1
  final bool isComplete;
  final bool isCancelled;
  final String? errorMessage;

  FileProcessingProgress({
    required this.progress,
    this.isComplete = false,
    this.isCancelled = false,
    this.errorMessage,
  });

  FileProcessingProgress copyWith({
    double? progress,
    bool? isComplete,
    bool? isCancelled,
    String? errorMessage,
  }) {
    return FileProcessingProgress(
      progress: progress ?? this.progress,
      isComplete: isComplete ?? this.isComplete,
      isCancelled: isCancelled ?? this.isCancelled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  FileProcessingProgress.initial()
      : progress = 0,
        isComplete = false,
        isCancelled = false,
        errorMessage = null;

  FileProcessingProgress.completed()
      : progress = 1,
        isComplete = true,
        isCancelled = false,
        errorMessage = null;

  FileProcessingProgress.cancelled({
    required double currentProgress,
  })  : progress = currentProgress,
        isComplete = false,
        isCancelled = true,
        errorMessage = null;

  FileProcessingProgress.failed({
    required String message,
    required double currentProgress,
  })  : progress = currentProgress,
        isComplete = false,
        isCancelled = false,
        errorMessage = message;
}
