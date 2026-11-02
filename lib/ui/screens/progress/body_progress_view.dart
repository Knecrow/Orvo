import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/bmi_calculator.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/app_line_chart.dart';
import '../../components/swipeable_row.dart';
import '../body/log_weight_sheet.dart';
import 'metric_stat_box.dart';

class BodyProgressView extends StatelessWidget {
  final AppStore store;

  const BodyProgressView({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final unit = store.profile?.unit ?? WeightUnit.kg;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';
    final entries = store.bodyEntries;

    final currentWeightKg = entries.isNotEmpty
        ? entries.first.weightKg
        : store.profile?.weightKg ?? 70.0;
    final currentWeightStr = formatWeightValue(currentWeightKg, unit);

    final heightCm = store.profile?.heightCm ?? 175.0;
    final bmiResult = calculateBmi(currentWeightKg, heightCm);
    final bmiStr = bmiResult != null ? bmiResult.formattedValue : '-';

    String deltaStr = '-';
    if (entries.length >= 2) {
      final diffKg = entries.first.weightKg - entries.last.weightKg;
      final diffDisplay = kgToUnit(diffKg.abs(), unit);
      final sign = diffKg > 0 ? '+' : (diffKg < 0 ? '-' : '');
      deltaStr = '$sign${diffDisplay.toStringAsFixed(1)} $unitLabel';
    }

    final chartPoints = entries.reversed.map((e) {
      final date = DateTime.tryParse(e.date) ?? DateTime.now();
      final val = kgToUnit(e.weightKg, unit);
      return ChartDataPoint(
        date: date,
        value: (val * 10).round() / 10,
        label: formatDate(date),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  currentWeightStr,
                  style: typography.largeTitle.merge(typography.tabularNums).copyWith(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        height: 1.0,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  unitLabel,
                  style: typography.body.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 38,
              child: AppButton(
                label: '+ Log Weight',
                variant: ButtonVariant.secondary,
                onPress: () {
                  showAppBottomSheet(
                    context: context,
                    child: LogWeightSheet(
                      unit: unit,
                      onSave: (entry) => store.saveBodyEntry(entry),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: MetricStatBox(label: 'BMI Index', value: bmiStr),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricStatBox(label: 'Total Change', value: deltaStr),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (chartPoints.length < 2)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              'Log at least 2 entries to see your weight trend curve.',
              style: typography.secondary.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Semantics(
              label: 'Body weight chart, ${chartPoints.length} entries',
              child: AppLineChart(dataPoints: chartPoints, unit: unitLabel),
            ),
          ),
        const SizedBox(height: 24),
        Text(
          'History',
          style: typography.body.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ...entries.map((entry) {
          final date = DateTime.tryParse(entry.date) ?? DateTime.now();
          final formattedDate = formatDate(date);
          final weightDisplay = formatWeightValue(entry.weightKg, unit);

          return SwipeableRow(
            itemKey: ValueKey(entry.id),
            onDelete: () => store.deleteBodyEntry(entry.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Center(
                      child: Icon(Icons.monitor_weight_outlined,
                          size: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      formattedDate,
                      style: typography.body.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    '$weightDisplay $unitLabel',
                    style: typography.body.merge(typography.tabularNums).copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
