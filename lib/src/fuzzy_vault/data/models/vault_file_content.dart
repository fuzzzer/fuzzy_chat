class VaultFileContent {
  const VaultFileContent({
    required this.fileName,
    required this.fileBytes,
  });

  final String fileName;
  final List<int> fileBytes;

  factory VaultFileContent.fromJson(Map<String, dynamic> json) {
    return VaultFileContent(
      fileName: json['fileName'] as String,
      fileBytes: List<int>.from(json['fileBytes'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileBytes': fileBytes,
    };
  }

  VaultFileContent copyWith({
    String? fileName,
    List<int>? fileBytes,
  }) {
    return VaultFileContent(
      fileName: fileName ?? this.fileName,
      fileBytes: fileBytes ?? this.fileBytes,
    );
  }
}
