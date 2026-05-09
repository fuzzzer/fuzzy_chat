class VaultNoteContent {
  const VaultNoteContent({
    required this.delta,
    required this.plainText,
  });

  final List<Map<String, dynamic>> delta;
  final String plainText;

  factory VaultNoteContent.fromJson(Map<String, dynamic> json) {
    return VaultNoteContent(
      delta: (json['delta'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      plainText: json['plainText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delta': delta,
      'plainText': plainText,
    };
  }

  VaultNoteContent copyWith({
    List<Map<String, dynamic>>? delta,
    String? plainText,
  }) {
    return VaultNoteContent(
      delta: delta ?? this.delta,
      plainText: plainText ?? this.plainText,
    );
  }
}
