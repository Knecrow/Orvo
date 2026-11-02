import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/platform/motion_presets.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';
import 'chart_painter.dart';

class ChartDataPoint {
  final DateTime date;
  final double value;
  final String label;

  const ChartDataPoint({
    required this.date,
    required this.value,
    required this.label,
  });
}

class AppLineChart extends StatefulWidget {
  final List<ChartDataPoint> dataPoints;
  final String unit;

  const AppLineChart({
    super.key,
    required this.dataPoints,
    required this.unit,
  });

  @override
  State<AppLineChart> createState() => _AppLineChartState();
}

class _AppLineChartState extends State<AppLineChart> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _drawInAnimation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: MotionPresets.chartDrawIn,
    );
    _drawInAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!MotionPresets.isReducedMotion(context)) {
        _animController.forward();
      } else {
        _animController.value = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    if (widget.dataPoints.length < 2) {
      return const SizedBox.shrink();
    }

    final points = widget.dataPoints;
    final values = points.map((p) => p.value).toList();
    final minVal = values.reduce(min);
    final maxVal = values.reduce(max);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    ChartDataPoint? selectedPoint;
    if (_selectedIndex != null && _selectedIndex! >= 0 && _selectedIndex! < points.length) {
      selectedPoint = points[_selectedIndex!];
    }

    final midVal = minVal + range / 2;
    final yLabels = [maxVal, midVal, minVal];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: selectedPoint != null
              ? _CalloutBubble(
                  text: '${selectedPoint.label}  ${selectedPoint.value.toStringAsFixed(1)} ${widget.unit}',
                  accentColor: colors.accent,
                  typography: typography,
                )
              : const SizedBox(height: 28),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 180,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const leftMargin = 40.0;
              return GestureDetector(
                onTapDown: (details) {
                  final width = constraints.maxWidth - leftMargin;
                  final x = (details.localPosition.dx - leftMargin).clamp(0.0, width);
                  final ratio = x / width;
                  final index = (ratio * (points.length - 1)).round();
                  setState(() => _selectedIndex = index);
                  AppHaptics.light();
                },
                child: AnimatedBuilder(
                  animation: _drawInAnimation,
                  builder: (context, _) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, 180),
                      painter: ChartPainter(
                        points: points,
                        progress: _drawInAnimation.value,
                        selectedIndex: _selectedIndex,
                        colors: colors,
                        typography: typography,
                        minVal: minVal,
                        maxVal: maxVal,
                        range: range,
                        yLabels: yLabels,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(points.first.label, style: typography.label.copyWith(color: colors.textSecondary, fontSize: 10)),
              Text(points[points.length ~/ 2].label, style: typography.label.copyWith(color: colors.textSecondary, fontSize: 10)),
              Text(points.last.label, style: typography.label.copyWith(color: colors.textSecondary, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalloutBubble extends StatelessWidget {
  final String text;
  final Color accentColor;
  final dynamic typography;

  const _CalloutBubble({
    required this.text,
    required this.accentColor,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(AppRadius.tiny + 2),
      ),
      child: Text(
        text,
        style: typography.label.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        maxLines: 1,
      ),
    );
  }
}
