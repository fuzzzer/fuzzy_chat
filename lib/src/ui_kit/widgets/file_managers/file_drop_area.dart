import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class FileDropArea extends StatefulWidget {
  final Widget child;
  final void Function(List<String> filePaths) onDropped;

  const FileDropArea({
    super.key,
    required this.child,
    required this.onDropped,
  });

  @override
  State<FileDropArea> createState() => _FileDropAreaState();
}

class _FileDropAreaState extends State<FileDropArea> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: (details) {
        final filePaths = details.files.map((f) => f.path).toList();
        widget.onDropped(filePaths);
        setState(() => _dragging = false);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (_dragging)
            ColoredBox(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Text(
                  context.fuzzyChatLocalizations.dropFilesHere,
                  style: context.uiTextStyles.bodyLargeBold20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
