import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';

class CustomProgress extends LeafRenderObjectWidget {
  const CustomProgress({
    super.key,
    required this.thumbSize,
    required this.thumbColor,
  });

  final double thumbSize;
  final Color thumbColor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomProgress(
      size: thumbSize,
      color: thumbColor,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderCustomProgress renderObject) {
    renderObject
      .._thumbColor = thumbColor
      .._thumbSize = thumbSize;
  }
}

class RenderCustomProgress extends RenderBox {
  RenderCustomProgress({
    required double size,
    required Color color,
  })  : _thumbColor = color,
        _thumbSize = size {
    _drag = VerticalDragGestureRecognizer()
      ..onStart = (details) {
        print(details);
        update(details.localPosition);
      }
      ..onUpdate = (details) {
        update(details.localPosition);
      };
  }

  double position = 0;

  VerticalDragGestureRecognizer? _drag;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _drag!.addPointer(event);
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  Color _thumbColor;

  Color get thumbColor => _thumbColor;
  set thumbColor(Color value) {
    if (thumbColor == value) {
      return;
    }

    _thumbColor = value;
    markNeedsPaint();
  }

  double _thumbSize;

  double get thumbSize => _thumbSize;
  set thumbSize(double value) {
    if (thumbSize == value) {
      return;
    }

    _thumbSize = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    final desiredWidth = constraints.minWidth;
    final desiredHeight = constraints.maxHeight;

    final desiredSize = Size(desiredWidth, desiredHeight);
    size = constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    final dotPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 4;

    final spacing = size.height / 20;

    for (var i = 0; i < 20; i++) {
      double x = i % 5 == 0 || i == 0 ? 40 : 30;

      dotPaint.strokeWidth = i % 5 == 0 || i == 0 ? 4 : 2;

      final upper = Offset(size.width - 20, spacing * i + 10);
      final lower = Offset(size.width - x, spacing * i + 10);

      canvas.drawLine(upper, lower, dotPaint);
    }

    final barPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final barUpper = Offset(size.width, 0);
    final barLower = Offset(size.width, size.height);

    canvas.drawLine(barUpper, barLower, barPaint);

    for (var i = 0; i < 20; i++) {
      double x = i % 5 == 0 || i == 0 ? 40 : 30;

      dotPaint.strokeWidth = i % 5 == 0 || i == 0 ? 4 : 2;

      final upper = Offset(size.width + 20, spacing * i + 10);
      final lower = Offset(size.width + x, spacing * i + 10);

      canvas.drawLine(upper, lower, dotPaint);
    }

    final centerX = size.width / 2;

    final thumbPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    // draw active bar
    final start = Offset(centerX, size.height - position);
    final end = Offset(centerX, size.height - position);

    canvas.drawLine(start, end, thumbPaint);

    final center = Offset(centerX, size.height - position);
    canvas.drawCircle(center, 10, thumbPaint);
  }

  void update(Offset pos) {
    var dy = pos.dy.clamp(0, size.height);
    position = double.parse((dy / size.height).toStringAsFixed(1));
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}
