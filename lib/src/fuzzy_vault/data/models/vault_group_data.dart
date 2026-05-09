import '../../storage/storage_models/stored_vault_group.dart';

class VaultGroupData {
  const VaultGroupData({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorIndex,
    required this.sortOrder,
    required this.hasCustomPassword,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String emoji;
  final int colorIndex;
  final int sortOrder;
  final bool hasCustomPassword;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const String generalGroupId = 'general';
  static const String generalGroupName = 'General';

  factory VaultGroupData.fromStored(StoredVaultGroup stored) {
    return VaultGroupData(
      id: stored.groupId,
      name: stored.name,
      emoji: stored.emoji,
      colorIndex: stored.colorIndex,
      sortOrder: stored.sortOrder,
      hasCustomPassword: stored.hasCustomPassword,
      createdAt: stored.createdAt,
      updatedAt: stored.updatedAt,
    );
  }

  VaultGroupData copyWith({
    String? id,
    String? name,
    String? emoji,
    int? colorIndex,
    int? sortOrder,
    bool? hasCustomPassword,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VaultGroupData(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorIndex: colorIndex ?? this.colorIndex,
      sortOrder: sortOrder ?? this.sortOrder,
      hasCustomPassword: hasCustomPassword ?? this.hasCustomPassword,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
