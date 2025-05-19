import 'file_processing_status.dart';

class FileProcessingData {
  final String chatId;
  final String chatName;
  final DateTime encryptionStartTime;
  final bool isProcessed;
  final String inputFilePath;
  final String? outputFilePath;
  final FileProcessingStatus status;
  final double progress; // value between 0 and 1

  const FileProcessingData({
    required this.chatId,
    required this.chatName,
    required this.inputFilePath,
    required this.encryptionStartTime,
    this.isProcessed = false,
    this.outputFilePath,
    this.status = FileProcessingStatus.pending,
    this.progress = 0.0,
  });

  FileProcessingData copyWith({
    String? chatId,
    String? chatName,
    DateTime? encryptionStartTime,
    bool? isProcessed,
    String? inputFilePath,
    String? outputFilePath,
    FileProcessingStatus? status,
    double? progress,
  }) =>
      FileProcessingData(
        chatId: chatId ?? this.chatId,
        chatName: chatName ?? this.chatName,
        encryptionStartTime: encryptionStartTime ?? this.encryptionStartTime,
        isProcessed: isProcessed ?? this.isProcessed,
        inputFilePath: inputFilePath ?? this.inputFilePath,
        outputFilePath: outputFilePath ?? this.outputFilePath,
        status: status ?? this.status,
        progress: progress ?? this.progress,
      );

  @override
  String toString() {
    return 'FileProcessingData(chatId: $chatId, chatName: $chatName, encryptionStartTime: $encryptionStartTime, isProcessed: $isProcessed, inputFilePath: $inputFilePath, outputFilePath: $outputFilePath, status: $status, progress: $progress)';
  }
}
