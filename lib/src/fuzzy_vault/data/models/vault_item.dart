import 'vault_file_content.dart';
import 'vault_item_metadata.dart';
import 'vault_note_content.dart';
import 'vault_password_content.dart';

class VaultItem {
  const VaultItem({
    required this.metadata,
    this.passwordContent,
    this.noteContent,
    this.fileContent,
  });

  final VaultItemMetadata metadata;
  final VaultPasswordContent? passwordContent;
  final VaultNoteContent? noteContent;
  final VaultFileContent? fileContent;

  VaultItem copyWith({
    VaultItemMetadata? metadata,
    VaultPasswordContent? passwordContent,
    VaultNoteContent? noteContent,
    VaultFileContent? fileContent,
  }) {
    return VaultItem(
      metadata: metadata ?? this.metadata,
      passwordContent: passwordContent ?? this.passwordContent,
      noteContent: noteContent ?? this.noteContent,
      fileContent: fileContent ?? this.fileContent,
    );
  }
}
