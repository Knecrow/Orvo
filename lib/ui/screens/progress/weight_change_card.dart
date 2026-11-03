import 'package:flutter/material.dart';
import '../../../core/logic/analytics_engine.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/body_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_line_chart.dart';

class WeightChangeCard extends StatelessWidget {
  final List<BodyEntry> entries;
  final WeightUnit unit;
  final VoidCallback onLogWeight;

  const WeightChangeCard({
    super.key,
    required this.entries,
    required this.unit,
    required this.onLogWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';

    final weightStat = calculateWeightChange(entries);

    final chartPoints = entries.reversed.map((e) {
      final date = DateTime.tryParse(e.date) ?? DateTime.now();
      final val = kgToUnit(e.weightKg, unit);
      return ChartDataPoint(
        date: date,
        value: (val * 10).round() / 10,
        label: formatDate(date),
      );
    }).toList();

    String deltaLabel = 'No change';
    if (weightStat != null) {
      final diffDisplay = kgToUnit(weightStat.diffKg.abs(), unit);
      final sign = weightStat.diffKg > 0
          ? '+'
          : (weightStat.diffKg < 0 ? '-' : '');
      deltaLabel =
          '$sign${diffDisplay.toStringAsFixed(1)} $unitLabel (${weightStat.percentChange.toStringAsFixed(1)}%)';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weight Change',
                style: typography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              if (weightStat != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    deltaLabel,
                    style: typography.label.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (chartPoints.length < 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Log at least 2 entries to see your weight trend curve.',
                  style: typography.secondary
                      .copyWith(color: const Color(0xFF8E8D88), fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else ...[
            Semantics(
              label: 'Weight change progression chart',
              child: AppLineChart(dataPoints: chartPoints, unit: unitLabel),
            ),
          ],
        ],
      ),
    );
  }
}

