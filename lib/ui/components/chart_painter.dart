import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import 'app_line_chart.dart';

class ChartPainter extends CustomPainter {
  final List<ChartDataPoint> points;
  final double progress;
  final int? selectedIndex;
  final dynamic colors;
  final dynamic typography;
  final double minVal;
  final double maxVal;
  final double range;
  final List<double> yLabels;

  ChartPainter({
    required this.points,
    required this.progress,
    required this.selectedIndex,
    required this.colors,
    required this.typography,
    required this.minVal,
    required this.maxVal,
    required this.range,
    required this.yLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftMargin = 40.0;
    const bottomMargin = 4.0;
    final chartWidth = size.width - leftMargin;
    final chartHeight = size.height - bottomMargin;

    // Y-axis labels
    final labelStyle = TextStyle(
      color: colors.textSecondary as Color,
      fontSize: 10,
      fontFamily: 'Inter',
    );
    for (int i = 0; i < yLabels.length; i++) {
      final normY = (yLabels[i] - minVal) / range;
      final y = chartHeight - (normY * (chartHeight - 20)) - 10;
      final tp = TextPainter(
        text: TextSpan(text: yLabels[i].toStringAsFixed(0), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftMargin - tp.width - 6, y - tp.height / 2));

      if (i == yLabels.length - 1) {
        final gridPaint = Paint()
          ..color = (colors.border as Color)
          ..strokeWidth = AppLayout.hairlineWidth;
        canvas.drawLine(Offset(leftMargin, y), Offset(size.width, y), gridPaint);
      }
    }

    // Compute point offsets
    final offsets = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final x = leftMargin + (i / (points.length - 1)) * chartWidth;
      final normY = (points[i].value - minVal) / range;
      final y = chartHeight - (normY * (chartHeight - 20)) - 10;
      offsets.add(Offset(x, y));
    }

    final linePaint = Paint()
      ..color = colors.accent as Color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (offsets.isNotEmpty) {
      path.moveTo(offsets.first.dx, offsets.first.dy);
      final currentMaxX = leftMargin + chartWidth * progress;

      for (int i = 1; i < offsets.length; i++) {
        if (offsets[i].dx <= currentMaxX) {
          final prev = offsets[i - 1];
          final curr = offsets[i];
          final cpX = (prev.dx + curr.dx) / 2;
          path.cubicTo(cpX, prev.dy, cpX, curr.dy, curr.dx, curr.dy);
        } else {
          final prev = offsets[i - 1];
          final curr = offsets[i];
          final t = (currentMaxX - prev.dx) / (curr.dx - prev.dx);
          final interpY = prev.dy + t * (curr.dy - prev.dy);
          path.lineTo(currentMaxX, interpY);
          break;
        }
      }
    }
    canvas.drawPath(path, linePaint);

    if (selectedIndex != null && selectedIndex! < offsets.length && progress >= 1.0) {
      final selOffset = offsets[selectedIndex!];

      final dashedPaint = Paint()
        ..color = (colors.border as Color)
        ..strokeWidth = 1.0;
      final baseY = chartHeight - 10;
      var startY = selOffset.dy + 8;
      while (startY < baseY) {
        canvas.drawLine(Offset(selOffset.dx, startY), Offset(selOffset.dx, min(startY + 4, baseY)), dashedPaint);
        startY += 8;
      }

      final outerPaint = Paint()..color = (colors.background as Color);
      canvas.drawCircle(selOffset, 6.5, outerPaint);
      final dotPaint = Paint()..color = colors.accent as Color;
      canvas.drawCircle(selOffset, 4.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.selectedIndex != selectedIndex;
  }
}

