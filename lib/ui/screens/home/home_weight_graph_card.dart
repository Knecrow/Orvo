import 'package:flutter/material.dart';
import '../../../core/logic/analytics_engine.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/body_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/platform/motion_presets.dart';
import '../../../core/theme/theme_provider.dart';
import 'hero_curve_painter.dart';

class HomeWeightGraphCard extends StatefulWidget {
  final List<BodyEntry> entries;
  final WeightUnit unit;
  final VoidCallback onLogWeight;

  const HomeWeightGraphCard({
    super.key,
    required this.entries,
    required this.unit,
    required this.onLogWeight,
  });

  @override
  State<HomeWeightGraphCard> createState() => _HomeWeightGraphCardState();
}

class _HomeWeightGraphCardState extends State<HomeWeightGraphCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _drawIn;
  int? _hoverIndex;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: MotionPresets.chartDrawIn,
    );
    _drawIn = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<double> _generatePoints() {
    final entries = widget.entries;
    if (entries.isEmpty) {
      return [70.0, 70.0, 70.0, 70.0, 70.0];
    }
    final points = entries.reversed.map((e) => kgToUnit(e.weightKg, widget.unit)).toList();
    if (points.length == 1) {
      return [points.first, points.first, points.first, points.first];
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final unitLabel = widget.unit == WeightUnit.kg ? 'kg' : 'lb';

    final points = _generatePoints();
    final weightStat = calculateWeightChange(widget.entries);
    final currentWeight = points.isNotEmpty ? points.last : 70.0;

    String deltaLabel = '0.0 $unitLabel';
    if (weightStat != null) {
      final diffDisplay = kgToUnit(weightStat.diffKg.abs(), widget.unit);
      final sign = weightStat.diffKg > 0 ? '+' : (weightStat.diffKg < 0 ? '-' : '');
      deltaLabel = '$sign${diffDisplay.toStringAsFixed(1)} $unitLabel';
    }

    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        widget.onLogWeight();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: colors.surfaceDark,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thin header: WEIGHT + current value and delta badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WEIGHT',
                  style: typography.label.copyWith(
                    color: const Color(0xFF8E8D88),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${currentWeight.toStringAsFixed(1)} $unitLabel',
                      style: typography.label.merge(typography.tabularNums).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        deltaLabel,
                        style: typography.label.merge(typography.tabularNums).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Thin 60px sparkline curve
            SizedBox(
              height: 60,
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
                          size: Size(constraints.maxWidth, 60),
                          painter: HeroCurvePainter(
                            points: points,
                            progress: _drawIn.value,
                            accentColor: colors.accent,
                            highlightIndex: _hoverIndex ?? (points.length - 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

