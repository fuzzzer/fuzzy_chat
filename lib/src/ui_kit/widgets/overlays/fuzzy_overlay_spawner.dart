import 'package:flutter/material.dart';

class FuzzyOverlaySpawner<T> extends StatefulWidget {
  const FuzzyOverlaySpawner({
    super.key,
    required this.spawnedChild,
    required this.child,
    this.splashRadius,
  });

  final Widget spawnedChild;
  final Widget child;
  final BorderRadius? splashRadius;

  @override
  State<FuzzyOverlaySpawner<T>> createState() => _FuzzyOverlaySpawnerState<T>();
}

class _FuzzyOverlaySpawnerState<T> extends State<FuzzyOverlaySpawner<T>> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _showMenu() async {
    focusNode.requestFocus();

    final button = context.findRenderObject()! as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero),
        button.localToGlobal(Offset.zero),
      ),
      Offset.zero & overlay.size,
    );

    final singlePopupItem = PopupMenuItem<T>(
      enabled: false,
      padding: EdgeInsets.zero,
      child: widget.spawnedChild,
    );

    await showMenu<T>(
      context: context,
      position: position,
      items: [singlePopupItem],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.transparent,
      shadowColor: Colors.transparent,
    );

    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      child: InkWell(
        onTap: _showMenu,
        borderRadius: widget.splashRadius ?? BorderRadius.circular(100),
        child: widget.child,
      ),
    );
  }
}
