import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:uuid/uuid.dart';

class VaultItemEditorPagePayload {
  final VaultItemType type;
  final VaultItem? existingItem; // null if creating a new item

  const VaultItemEditorPagePayload({
    required this.type,
    this.existingItem,
  });
}

class VaultItemEditorPage extends StatefulWidget {
  final VaultItemEditorPagePayload payload;

  const VaultItemEditorPage({super.key, required this.payload});

  @override
  State<VaultItemEditorPage> createState() => _VaultItemEditorPageState();
}

class _VaultItemEditorPageState extends State<VaultItemEditorPage> {
  late VaultItemType _type;
  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _urlController;
  late final TextEditingController _notesController;
  
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _type = widget.payload.type;
    
    final item = widget.payload.existingItem;
    _titleController = TextEditingController(text: item?.metadata.title ?? '');
    
    _usernameController = TextEditingController(text: item?.passwordContent?.username ?? '');
    _passwordController = TextEditingController(text: item?.passwordContent?.password ?? '');
    _urlController = TextEditingController(text: item?.passwordContent?.url ?? '');
    
    // Use notesController for both Password's small notes and Note's full content
    final noteText = _type == VaultItemType.password 
      ? item?.passwordContent?.notes ?? ''
      : item?.noteContent?.plainText ?? '';
    _notesController = TextEditingController(text: noteText);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSave(BuildContext context) async {
    String finalTitle = _titleController.text.trim();
    if (_type == VaultItemType.password) {
      if (_usernameController.text.trim().isNotEmpty) {
        finalTitle = _usernameController.text.trim();
      } else {
        finalTitle = widget.payload.existingItem?.metadata.title ?? 'Untitled';
        if (finalTitle.isEmpty) {
          finalTitle = 'Untitled';
        }
      }
    }

    if (finalTitle.isEmpty) {
      finalTitle = 'Untitled';
    }

    final now = DateTime.now();
    final metadata = widget.payload.existingItem?.metadata.copyWith(
      title: finalTitle,
      updatedAt: now,
      contentVersion: (widget.payload.existingItem?.metadata.contentVersion ?? 0) + 1,
    ) ?? VaultItemMetadata(
      id: const Uuid().v4(),
      title: finalTitle,
      type: _type,
      groupId: 'general', // Default for now
      tags: [],
      isFavorite: false,
      hasCustomPassword: false,
      createdAt: now,
      updatedAt: now,
      contentVersion: 1,
    );

    VaultPasswordContent? pwdContent;
    VaultNoteContent? noteContent;

    if (_type == VaultItemType.password) {
      pwdContent = VaultPasswordContent(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        url: _urlController.text.trim().isEmpty ? null : _urlController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
    } else {
      noteContent = VaultNoteContent(
        delta: [],
        plainText: _notesController.text.trim(),
      );
    }

    final item = VaultItem(
      metadata: metadata,
      passwordContent: pwdContent,
      noteContent: noteContent,
    );

    final masterKey = context.read<VaultAuthCubit>().state.masterKey;
    if (masterKey == null) return;

    final repo = sl.get<VaultRepository>();

    if (widget.payload.existingItem == null) {
      await repo.createItem(item, masterKey);
    } else {
      await repo.updateItem(item, masterKey);
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FuzzyScaffold(
      hasAutomaticBackButton: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FuzzyHeader(
              title: widget.payload.existingItem == null 
                  ? (_type == VaultItemType.password ? 'New Password' : 'New Note')
                  : 'Edit Item',
              leftAction: const FuzzyBackButton(),
            ),
            Expanded(
              child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_type != VaultItemType.password) ...[
              FuzzyTextField(
                controller: _titleController,
                labelText: 'Title',
              ),
              const SizedBox(height: 16),
            ],
            
            if (_type == VaultItemType.password) ...[
              FuzzyTextField(
                controller: _usernameController,
                labelText: 'Username / Email',
              ),
              const SizedBox(height: 16),
              FuzzyTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: context.uiColors.secondaryTextColor,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              const SizedBox(height: 16),
              FuzzyTextField(
                controller: _urlController,
                labelText: 'URL (Website)',
              ),
              const SizedBox(height: 16),
            ],
            
            FuzzyTextField(
              controller: _notesController,
              labelText: _type == VaultItemType.password ? 'Notes (Optional)' : 'Secure Note',
              maxLines: _type == VaultItemType.password ? 3 : 15,
            ),
            
            const SizedBox(height: 40),
            FuzzyButton(
              text: 'Save',
              onTap: () => _onSave(context),
            ),
          ],
        ),
      ),
    ),
          ],
        ),
      ),
    );
  }
}
