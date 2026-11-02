import 'dart:math';
import 'package:flutter/material.dart';

class HeroCurvePainter extends CustomPainter {
  final List<double> points;
  final double progress;
  final Color accentColor;
  final int highlightIndex;

  HeroCurvePainter({
    required this.points,
    required this.progress,
    required this.accentColor,
    required this.highlightIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minV = points.reduce(min);
    final maxV = points.reduce(max);
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);

    final offsets = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final normY = (points[i] - minV) / range;
      final y = size.height - 10 - (normY * (size.height - 20));
      offsets.add(Offset(x, y));
    }

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    final limitX = size.width * progress;

    for (int i = 1; i < offsets.length; i++) {
      if (offsets[i].dx <= limitX) {
        final prev = offsets[i - 1];
        final curr = offsets[i];
        final cpX = (prev.dx + curr.dx) / 2;
        path.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
      } else {
        break;
      }
    }

    final strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, strokePaint);

    final safeIdx = highlightIndex.clamp(0, offsets.length - 1);
    if (progress >= 1.0) {
      final nodePos = offsets[safeIdx];
      canvas.drawCircle(
        nodePos,
        5.5,
        Paint()..color = accentColor..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        nodePos,
        2.5,
        Paint()..color = Colors.white..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HeroCurvePainter old) {
    return old.progress != progress || old.highlightIndex != highlightIndex;
  }
}

