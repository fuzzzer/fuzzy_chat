import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fuzzy_chat/lib.dart';

class VaultRepository {
  const VaultRepository({
    required this.itemDataSource,
    required this.groupDataSource,
    required this.fileDataSource,
    required this.cryptoRepository,
  });

  final VaultItemLocalDataSource itemDataSource;
  final VaultGroupLocalDataSource groupDataSource;
  final VaultFileDataSource fileDataSource;
  final VaultCryptoRepository cryptoRepository;

  Stream<VaultDataUpdated> get vaultDataUpdates => fuzzyHub.on<VaultDataUpdated>();

  Future<VaultResponse<VaultMetadata>> getMetadata() async {
    try {
      final bytes = await fileDataSource.readMeta();
      if (bytes == null) {
        return const VaultFailure(VaultFailureType.vaultNotInitialized);
      }
      final jsonString = utf8.decode(bytes);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      
      return VaultSuccess(VaultMetadata(
        vaultId: jsonMap['vaultId'] as String,
        verificationToken: jsonMap['verificationToken'] as String,
        masterSalt: jsonMap['masterSalt'] as String,
        createdAt: DateTime.parse(jsonMap['createdAt'] as String),
        lastUnlockedAt: DateTime.parse(jsonMap['lastUnlockedAt'] as String),
        autoLockMinutes: jsonMap['autoLockMinutes'] as int,
        customDirectoryPath: jsonMap['customDirectoryPath'] as String?,
      ),);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageReadError, message: e.toString());
    }
  }

  Future<VaultResponse<void>> saveMetadata(VaultMetadata metadata) async {
    try {
      final jsonMap = {
        'vaultId': metadata.vaultId,
        'verificationToken': metadata.verificationToken,
        'masterSalt': metadata.masterSalt,
        'createdAt': metadata.createdAt.toIso8601String(),
        'lastUnlockedAt': metadata.lastUnlockedAt.toIso8601String(),
        'autoLockMinutes': metadata.autoLockMinutes,
        'customDirectoryPath': metadata.customDirectoryPath,
      };
      final bytes = utf8.encode(jsonEncode(jsonMap));
      await fileDataSource.writeMetaAtomic(bytes);
      return const VaultSuccess(null);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<VaultGroupData>> ensureGeneralGroup() async {
    try {
      var generalGroup = await groupDataSource.getGroup(VaultGroupData.generalGroupId);
      if (generalGroup == null) {
        generalGroup = StoredVaultGroup()
          ..groupId = VaultGroupData.generalGroupId
          ..name = VaultGroupData.generalGroupName
          ..emoji = '📁'
          ..colorIndex = 0
          ..sortOrder = 0
          ..hasCustomPassword = false
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();
        await groupDataSource.saveGroup(generalGroup);
      }
      return VaultSuccess(VaultGroupData.fromStored(generalGroup));
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<VaultItem>> createItem(
    VaultItem item,
    Uint8List masterKey, {
    String? customPassword,
  }) async {
    try {
      await ensureGeneralGroup();
      
      final content = item.metadata.type == VaultItemType.password 
          ? item.passwordContent 
          : item.noteContent;

      final encryptedRes = await cryptoRepository.encryptContent(
        content,
        masterKey,
        customPassword: customPassword,
      );

      if (encryptedRes is VaultFailure) {
        final failure = encryptedRes as VaultFailure;
        return VaultFailure(failure.type, message: failure.message);
      }
      final encryptedBytes = (encryptedRes as VaultSuccess<Uint8List>).data;

      await fileDataSource.writeItemAtomic(item.metadata.id, encryptedBytes);

      final storedItem = StoredVaultItem()
        ..itemId = item.metadata.id
        ..title = item.metadata.title
        ..groupId = item.metadata.groupId
        ..type = item.metadata.type
        ..tags = item.metadata.tags
        ..isFavorite = item.metadata.isFavorite
        ..hasCustomPassword = item.metadata.hasCustomPassword
        ..createdAt = item.metadata.createdAt
        ..updatedAt = item.metadata.updatedAt
        ..contentVersion = item.metadata.contentVersion;

      await itemDataSource.saveItem(storedItem);
      
      fuzzyHub.sendSignal(const VaultDataUpdated());
      return VaultSuccess(item);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<VaultItem>> getItem(
    String itemId,
    Uint8List masterKey, {
    String? customPassword,
  }) async {
    try {
      final storedItem = await itemDataSource.getItem(itemId);
      if (storedItem == null) {
        return const VaultFailure(VaultFailureType.itemNotFound);
      }

      final encryptedBytes = await fileDataSource.readItem(itemId);
      if (encryptedBytes == null) {
        return const VaultFailure(VaultFailureType.fileCorrupted, message: 'Encrypted blob missing');
      }

      final metadata = VaultItemMetadata.fromStored(storedItem);

      final decryptedRes = await cryptoRepository.decryptContent(
        Uint8List.fromList(encryptedBytes),
        masterKey,
        metadata.type,
        customPassword: customPassword,
      );

      if (decryptedRes is VaultFailure) {
        return VaultFailure(decryptedRes.type, message: decryptedRes.message);
      }

      final content = (decryptedRes as VaultSuccess<dynamic>).data;

      if (metadata.type == VaultItemType.password) {
        return VaultSuccess(VaultItem(
          metadata: metadata,
          passwordContent: content as VaultPasswordContent,
        ),);
      } else {
        return VaultSuccess(VaultItem(
          metadata: metadata,
          noteContent: content as VaultNoteContent,
        ),);
      }
    } catch (e) {
      return VaultFailure(VaultFailureType.storageReadError, message: e.toString());
    }
  }

  Future<VaultResponse<VaultItem>> updateItem(
    VaultItem item,
    Uint8List masterKey, {
    String? customPassword,
  }) async {
    try {
      final storedItem = await itemDataSource.getItem(item.metadata.id);
      if (storedItem == null) {
        return const VaultFailure(VaultFailureType.itemNotFound);
      }

      final updatedMetadata = item.metadata.copyWith(
        updatedAt: DateTime.now(),
        contentVersion: item.metadata.contentVersion + 1,
      );

      final content = updatedMetadata.type == VaultItemType.password 
          ? item.passwordContent 
          : item.noteContent;

      final encryptedRes = await cryptoRepository.encryptContent(
        content,
        masterKey,
        customPassword: customPassword,
      );

      if (encryptedRes is VaultFailure) {
        final failure = encryptedRes as VaultFailure;
        return VaultFailure(failure.type, message: failure.message);
      }
      final encryptedBytes = (encryptedRes as VaultSuccess<Uint8List>).data;

      await fileDataSource.writeItemAtomic(updatedMetadata.id, encryptedBytes);

      storedItem
        ..title = updatedMetadata.title
        ..groupId = updatedMetadata.groupId
        ..type = updatedMetadata.type
        ..tags = updatedMetadata.tags
        ..isFavorite = updatedMetadata.isFavorite
        ..hasCustomPassword = updatedMetadata.hasCustomPassword
        ..updatedAt = updatedMetadata.updatedAt
        ..contentVersion = updatedMetadata.contentVersion;

      await itemDataSource.saveItem(storedItem);
      
      fuzzyHub.sendSignal(const VaultDataUpdated());

      return VaultSuccess(item.copyWith(metadata: updatedMetadata));
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<void>> deleteItem(String itemId) async {
    try {
      await fileDataSource.deleteItem(itemId);
      await itemDataSource.deleteItem(itemId);
      
      fuzzyHub.sendSignal(const VaultDataUpdated());
      return const VaultSuccess(null);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<List<VaultItemMetadata>>> getAllItems() async {
    try {
      final items = await itemDataSource.getAllItems();
      return VaultSuccess(items.map(VaultItemMetadata.fromStored).toList());
    } catch (e) {
      return VaultFailure(VaultFailureType.storageReadError, message: e.toString());
    }
  }

  Future<VaultResponse<List<VaultItemMetadata>>> getItemsByGroup(String groupId) async {
    try {
      final items = await itemDataSource.getItemsByGroup(groupId);
      return VaultSuccess(items.map(VaultItemMetadata.fromStored).toList());
    } catch (e) {
      return VaultFailure(VaultFailureType.storageReadError, message: e.toString());
    }
  }

  Future<VaultResponse<List<VaultItemMetadata>>> searchItems(String query) async {
    try {
      final items = await itemDataSource.getAllItems();
      final q = query.toLowerCase();
      final filtered = items.where((i) {
        return i.title.toLowerCase().contains(q) || 
               i.tags.any((t) => t.toLowerCase().contains(q));
      }).map(VaultItemMetadata.fromStored).toList();
      return VaultSuccess(filtered);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageReadError, message: e.toString());
    }
  }

  Future<VaultResponse<VaultGroupData>> createGroup(VaultGroupData group) async {
    try {
      final storedGroup = StoredVaultGroup()
        ..groupId = group.id
        ..name = group.name
        ..emoji = group.emoji
        ..colorIndex = group.colorIndex
        ..sortOrder = group.sortOrder
        ..hasCustomPassword = group.hasCustomPassword
        ..createdAt = group.createdAt
        ..updatedAt = group.updatedAt;

      await groupDataSource.saveGroup(storedGroup);
      return VaultSuccess(group);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<List<VaultGroupData>>> getAllGroups() async {
    try {
      await ensureGeneralGroup();
      final groups = await groupDataSource.getAllGroups();
      return VaultSuccess(groups.map(VaultGroupData.fromStored).toList());
    } catch (e) {
      return VaultFailure(VaultFailureType.storageReadError, message: e.toString());
    }
  }

  Future<VaultResponse<VaultGroupData>> updateGroup(VaultGroupData group) async {
    try {
      final storedGroup = await groupDataSource.getGroup(group.id);
      if (storedGroup == null) {
        return const VaultFailure(VaultFailureType.groupNotFound);
      }

      storedGroup
        ..name = group.name
        ..emoji = group.emoji
        ..colorIndex = group.colorIndex
        ..sortOrder = group.sortOrder
        ..hasCustomPassword = group.hasCustomPassword
        ..updatedAt = DateTime.now();

      await groupDataSource.saveGroup(storedGroup);
      return VaultSuccess(VaultGroupData.fromStored(storedGroup));
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<void>> deleteGroup(String groupId) async {
    try {
      if (groupId == VaultGroupData.generalGroupId) {
        return const VaultFailure(VaultFailureType.generalGroupUndeletable);
      }

      final items = await itemDataSource.getItemsByGroup(groupId);
      for (final item in items) {
        item.groupId = VaultGroupData.generalGroupId;
        await itemDataSource.saveItem(item);
      }

      await groupDataSource.deleteGroup(groupId);
      return const VaultSuccess(null);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }

  Future<VaultResponse<void>> changeMasterPassword(String oldPassword, String newPassword) async {
    try {
      final metaRes = await getMetadata();
      if (metaRes is VaultFailure) return VaultFailure((metaRes as VaultFailure).type, message: (metaRes as VaultFailure).message);
      final oldMetadata = (metaRes as VaultSuccess<VaultMetadata>).data;

      final deriveRes = await cryptoRepository.verifyAndDeriveKey(oldPassword, oldMetadata);
      if (deriveRes is VaultFailure) return VaultFailure((deriveRes as VaultFailure).type, message: (deriveRes as VaultFailure).message);
      final oldKey = (deriveRes as VaultSuccess<Uint8List>).data;

      final itemsData = await itemDataSource.getAllItems();
      
      final encryptedItems = <String, Uint8List>{};
      for (final item in itemsData) {
        final bytes = await fileDataSource.readItem(item.itemId);
        if (bytes != null) encryptedItems[item.itemId] = Uint8List.fromList(bytes);
      }

      final newInitRes = await cryptoRepository.initializeVault(newPassword);
      if (newInitRes is VaultFailure) return VaultFailure((newInitRes as VaultFailure).type, message: (newInitRes as VaultFailure).message);
      final newMetadata = (newInitRes as VaultSuccess<VaultMetadata>).data;

      final newKeyRes = await cryptoRepository.verifyAndDeriveKey(newPassword, newMetadata);
      if (newKeyRes is VaultFailure) return VaultFailure((newKeyRes as VaultFailure).type, message: (newKeyRes as VaultFailure).message);
      final newKey = (newKeyRes as VaultSuccess<Uint8List>).data;

      final reencryptRes = await cryptoRepository.reencryptAll(encryptedItems, oldKey, newKey);
      if (reencryptRes is VaultFailure) return VaultFailure((reencryptRes as VaultFailure).type, message: (reencryptRes as VaultFailure).message);
      final newlyEncryptedItems = (reencryptRes as VaultSuccess<Map<String, Uint8List>>).data;

      for (final entry in newlyEncryptedItems.entries) {
        await fileDataSource.writeItemAtomic(entry.key, entry.value);
      }

      await saveMetadata(newMetadata);

      return const VaultSuccess(null);
    } catch (e) {
      return VaultFailure(VaultFailureType.storageWriteError, message: e.toString());
    }
  }
}
