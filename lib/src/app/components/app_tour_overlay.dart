import 'package:flutter/material.dart';
import 'package:fuzzzy_ui_kit/fuzzzy_ui_kit.dart';

import 'app_tour_step.dart';

void showAppTour(
  BuildContext context, {
  required List<AppTourStep> steps,
  required String nextLabel,
  required String doneLabel,
}) {
  if (steps.isEmpty) return;

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _AppTourOverlay(
      steps: steps,
      nextLabel: nextLabel,
      doneLabel: doneLabel,
      onFinished: () => entry.remove(),
    ),
  );
  Overlay.of(context, rootOverlay: true).insert(entry);
}

class _AppTourOverlay extends StatefulWidget {
  const _AppTourOverlay({
    required this.steps,
    required this.nextLabel,
    required this.doneLabel,
    required this.onFinished,
  });

  final List<AppTourStep> steps;
  final String nextLabel;
  final String doneLabel;
  final VoidCallback onFinished;

  @override
  State<_AppTourOverlay> createState() => _AppTourOverlayState();
}

class _AppTourOverlayState extends State<_AppTourOverlay> {
  int _index = 0;

  Rect? _targetRect(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return null;
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  void _advance() {
    if (_index >= widget.steps.length - 1) {
      widget.onFinished();
    } else {
      setState(() => _index++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_index];
    final rect = _targetRect(step.targetKey);

    if (rect == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onFinished());
      return const SizedBox.shrink();
    }

    final screenSize = MediaQuery.of(context).size;
    final holeRect = rect.inflate(6);
    final isLast = _index == widget.steps.length - 1;
    final showBubbleBelow = holeRect.top < screenSize.height / 2;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _advance,
            child: CustomPaint(
              painter: _SpotlightPainter(holeRect: holeRect),
              size: Size.infinite,
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          top: showBubbleBelow ? holeRect.bottom + 16 : null,
          bottom:
              showBubbleBelow ? null : screenSize.height - holeRect.top + 16,
          child: _TourBubble(
            step: step,
            index: _index,
            total: widget.steps.length,
            actionLabel: isLast ? widget.doneLabel : widget.nextLabel,
            onAction: _advance,
          ),
        ),
      ],
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter({required this.holeRect});

  final Rect holeRect;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()
      ..addRRect(RRect.fromRectAndRadius(holeRect, const Radius.circular(12)));
    final scrim = Path.combine(PathOperation.difference, background, hole);

    canvas
      ..drawPath(scrim, Paint()..color = Colors.black.withValues(alpha: 0.7))
      ..drawRRect(
        RRect.fromRectAndRadius(holeRect, const Radius.circular(12)),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.holeRect != holeRect;
}

class _TourBubble extends StatelessWidget {
  const _TourBubble({
    required this.step,
    required this.index,
    required this.total,
    required this.actionLabel,
    required this.onAction,
  });

  final AppTourStep step;
  final int index;
  final int total;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.fuzzzyColors;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.ground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}/$total',
              style: TextStyle(color: colors.inkMute, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              step.title,
              style: TextStyle(
                color: colors.ink,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              step.description,
              style: TextStyle(color: colors.inkMute, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FuzzzyButton(
                label: actionLabel,
                size: FuzzzyButtonSize.s,
                onPressed: onAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
