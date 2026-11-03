import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/models/workout.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/platform/motion_presets.dart';
import '../../../core/theme/theme_provider.dart';
import 'hero_curve_painter.dart';

class HeroChartCard extends StatefulWidget {
  final List<Workout> workouts;
  final VoidCallback onStartWorkout;

  const HeroChartCard({
    super.key,
    required this.workouts,
    required this.onStartWorkout,
  });

  @override
  State<HeroChartCard> createState() => _HeroChartCardState();
}

class _HeroChartCardState extends State<HeroChartCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _drawIn;
  int _selectedFilter = 1;
  int? _hoverIndex;

  static const _filters = ['1D', '1W', '1M', '1Y'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: MotionPresets.chartDrawIn);
    _drawIn = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<double> _generatePoints() {
    final days = _selectedFilter == 0 ? 7 : (_selectedFilter == 1 ? 14 : 30);
    final now = DateTime.now();
    final points = <double>[];

    for (int i = days - 1; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final dayWorkouts = widget.workouts.where((w) {
        final d = DateTime.tryParse(w.date);
        return d != null && d.year == day.year && d.month == day.month && d.day == day.day;
      }).toList();

      if (dayWorkouts.isNotEmpty) {
        var totalSets = 0;
        for (final w in dayWorkouts) {
          for (final e in w.exercises) {
            totalSets += e.sets.length;
          }
        }
        points.add(max(10.0, totalSets * 8.0));
      } else {
        final wave = 18.0 + 12.0 * sin(i * 0.7);
        points.add(wave);
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final points = _generatePoints();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${points.last.toInt()} kg',
                style: typography.label.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 120,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) {
                    final ratio = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
                    final idx = (ratio * (points.length - 1)).round();
                    setState(() => _hoverIndex = idx);
                    AppHaptics.light();
                  },
                  child: AnimatedBuilder(
                    animation: _drawIn,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, 120),
                        painter: HeroCurvePainter(
                          points: points,
                          progress: _drawIn.value,
                          accentColor: colors.accent,
                          highlightIndex: _hoverIndex ?? (points.length - 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_filters.length, (i) {
              final isSel = _selectedFilter == i;
              return GestureDetector(
                onTap: () {
                  AppHaptics.light();
                  setState(() => _selectedFilter = i);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF2E2E2E) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _filters[i],
                    style: typography.label.copyWith(
                      color: isSel ? Colors.white : const Color(0xFF757470),
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
