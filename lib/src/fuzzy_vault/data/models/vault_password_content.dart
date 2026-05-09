class VaultPasswordContent {
  const VaultPasswordContent({
    required this.username,
    required this.password,
    this.url,
    this.notes,
    this.customFields = const {},
  });

  final String username;
  final String password;
  final String? url;
  final String? notes;
  final Map<String, String> customFields;

  factory VaultPasswordContent.fromJson(Map<String, dynamic> json) {
    return VaultPasswordContent(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      url: json['url'] as String?,
      notes: json['notes'] as String?,
      customFields: (json['customFields'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'url': url,
      'notes': notes,
      'customFields': customFields,
    };
  }

  VaultPasswordContent copyWith({
    String? username,
    String? password,
    String? url,
    String? notes,
    Map<String, String>? customFields,
  }) {
    return VaultPasswordContent(
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      customFields: customFields ?? this.customFields,
    );
  }
}
