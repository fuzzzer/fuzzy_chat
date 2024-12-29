import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';
import 'package:permission_handler/permission_handler.dart';

typedef OnFilePathsSelected = void Function(List<String> filePaths);

class FileSelector extends StatefulWidget {
  final OnFilePathsSelected onSelected;
  final bool allowMultiple;
  final String buttonText;

  const FileSelector({
    super.key,
    required this.onSelected,
    this.allowMultiple = false,
    this.buttonText = 'Select File(s)',
  });

  @override
  State<FileSelector> createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelector> {
  bool _isRequesting = false;

  Future<bool> _requestStoragePermissionByPlatform() async {
    bool isGranted = true;

    if (Platform.isIOS || Platform.isAndroid) {
      isGranted = await _requestStoragePermission();
    }

    if (!isGranted) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            currentContextLocalization.storagePermissionDenied,
          ),
        ),
      );
      return false;
    }

    return isGranted;
  }

  Future<bool> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> _pickFiles() async {
    setState(() => _isRequesting = true);

    try {
      await _requestStoragePermissionByPlatform();

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.allowMultiple,
      );
      if (result != null && result.files.isNotEmpty) {
        final paths = turnPlatformFilesToPaths(result.files);
        if (paths.isNotEmpty) {
          widget.onSelected(paths);
        }
      }
    } catch (e) {
      debugPrint('File selection error: $e');
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            currentContextLocalization.errorPickingFiles,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
      }
    }
  }

  List<String> turnPlatformFilesToPaths(List<PlatformFile> files) {
    return files.where((f) => f.path != null).map((f) => f.path!).toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FuzzyChatLocalizations.of(context)!;

    return ElevatedButton.icon(
      icon: _isRequesting
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.file_open),
      label: Text(
        _isRequesting ? '${localizations.loading}...' : widget.buttonText,
      ),
      onPressed: _isRequesting ? null : _pickFiles,
    );
  }
}
