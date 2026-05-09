import '../../storage/storage_models/stored_vault_item.dart';
import 'vault_item_type.dart';

class VaultItemMetadata {
  const VaultItemMetadata({
    required this.id,
    required this.title,
    required this.type,
    required this.groupId,
    required this.tags,
    required this.isFavorite,
    required this.hasCustomPassword,
    required this.createdAt,
    required this.updatedAt,
    required this.contentVersion,
  });

  final String id;
  final String title;
  final VaultItemType type;
  final String groupId;
  final List<String> tags;
  final bool isFavorite;
  final bool hasCustomPassword;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int contentVersion;

  factory VaultItemMetadata.fromStored(StoredVaultItem stored) {
    return VaultItemMetadata(
      id: stored.itemId,
      title: stored.title,
      type: stored.type,
      groupId: stored.groupId,
      tags: List.from(stored.tags),
      isFavorite: stored.isFavorite,
      hasCustomPassword: stored.hasCustomPassword,
      createdAt: stored.createdAt,
      updatedAt: stored.updatedAt,
      contentVersion: stored.contentVersion,
    );
  }

  VaultItemMetadata copyWith({
    String? id,
    String? title,
    VaultItemType? type,
    String? groupId,
    List<String>? tags,
    bool? isFavorite,
    bool? hasCustomPassword,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? contentVersion,
  }) {
    return VaultItemMetadata(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      groupId: groupId ?? this.groupId,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      hasCustomPassword: hasCustomPassword ?? this.hasCustomPassword,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentVersion: contentVersion ?? this.contentVersion,
    );
  }
}
