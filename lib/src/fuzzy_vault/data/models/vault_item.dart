import 'vault_item_metadata.dart';
import 'vault_note_content.dart';
import 'vault_password_content.dart';

class VaultItem {
  const VaultItem({
    required this.metadata,
    this.passwordContent,
    this.noteContent,
  });

  final VaultItemMetadata metadata;
  final VaultPasswordContent? passwordContent;
  final VaultNoteContent? noteContent;

  VaultItem copyWith({
    VaultItemMetadata? metadata,
    VaultPasswordContent? passwordContent,
    VaultNoteContent? noteContent,
  }) {
    return VaultItem(
      metadata: metadata ?? this.metadata,
      passwordContent: passwordContent ?? this.passwordContent,
      noteContent: noteContent ?? this.noteContent,
    );
  }
}
