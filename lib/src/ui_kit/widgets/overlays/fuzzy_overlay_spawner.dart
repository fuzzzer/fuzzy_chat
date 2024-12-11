import 'package:flutter/material.dart';

class FuzzyOverlaySpawner<T> extends StatefulWidget {
  const FuzzyOverlaySpawner({
    super.key,
    required this.spawnedChildBuilder,
    required this.child,
    this.splashRadius,
    this.offset,
  });

  final Widget Function(BuildContext context, VoidCallback closeOverlay) spawnedChildBuilder;
  final Widget child;
  final BorderRadius? splashRadius;
  final Offset? offset;

  @override
  State<FuzzyOverlaySpawner<T>> createState() => _FuzzyOverlaySpawnerState<T>();
}

class _FuzzyOverlaySpawnerState<T> extends State<FuzzyOverlaySpawner<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOverlayVisible = false;

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (_isOverlayVisible) {
      _hideOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        _isOverlayVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hideOverlay,
              onPanStart: (_) => _hideOverlay(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              offset: widget.offset ?? Offset.zero,
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: widget.spawnedChildBuilder(context, _hideOverlay),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _toggleOverlay,
        borderRadius: widget.splashRadius ?? BorderRadius.circular(100),
        child: widget.child,
      ),
    );
  }
}
