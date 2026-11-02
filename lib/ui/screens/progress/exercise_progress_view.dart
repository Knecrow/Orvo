import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/autocomplete_engine.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';
import '../../components/app_line_chart.dart';
import '../../components/empty_state.dart';
import 'exercise_picker_sheet.dart';
import 'metric_stat_box.dart';

class ExerciseProgressView extends StatefulWidget {
  final AppStore store;
  final VoidCallback onStartWorkout;

  const ExerciseProgressView({
    super.key,
    required this.store,
    required this.onStartWorkout,
  });

  @override
  State<ExerciseProgressView> createState() => _ExerciseProgressViewState();
}

class _ExerciseProgressViewState extends State<ExerciseProgressView> {
  String? _selectedExercise;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final store = widget.store;
    final unit = store.profile?.unit ?? WeightUnit.kg;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';

    final allNames = extractExerciseNames(store.workouts, store.templates);
    if (_selectedExercise == null && allNames.isNotEmpty) {
      _selectedExercise = allNames.first;
    }

    final dataPoints = <ChartDataPoint>[];
    final historyEntries = <Map<String, dynamic>>[];
    var maxWeightOverall = 0.0;

    if (_selectedExercise != null) {
      final sortedWorkouts = [...store.workouts]..sort((a, b) {
          final da = DateTime.tryParse(a.date) ?? DateTime(1970);
          final db = DateTime.tryParse(b.date) ?? DateTime(1970);
          return da.compareTo(db);
        });

      for (final w in sortedWorkouts) {
        final match = w.exercises.cast().firstWhere(
          (e) => e.name.trim().toLowerCase() == _selectedExercise!.toLowerCase(),
          orElse: () => null,
        );

        if (match != null && match.sets.isNotEmpty) {
          var topWeight = 0.0;
          var topReps = 0;
          for (final s in match.sets) {
            if (s.weightKg > topWeight ||
                (s.weightKg == topWeight && s.reps > topReps)) {
              topWeight = s.weightKg;
              topReps = s.reps;
            }
          }

          if (topWeight > maxWeightOverall) maxWeightOverall = topWeight;

          final d = DateTime.tryParse(w.date) ?? DateTime.now();
          final converted = (kgToUnit(topWeight, unit) * 10).round() / 10;
          dataPoints.add(
              ChartDataPoint(date: d, value: converted, label: formatDate(d)));
          historyEntries
              .add({'date': d, 'weight': converted, 'reps': topReps});
        }
      }
    }

    final bestLiftStr = maxWeightOverall > 0
        ? '${formatWeightValue(maxWeightOverall, unit)} $unitLabel'
        : '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (allNames.isNotEmpty) ...[
          GestureDetector(
            onTap: () => showExercisePickerSheet(
              context: context,
              names: allNames,
              selectedExercise: _selectedExercise,
              onSelect: (name) => setState(() => _selectedExercise = name),
            ),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedExercise ?? '',
                    style: typography.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  Icon(AppIcons.chevronDown,
                      size: 20, color: colors.textPrimary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              child: MetricStatBox(label: 'Best Lift', value: bestLiftStr),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricStatBox(
                  label: 'Total Logs', value: '${dataPoints.length}'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (dataPoints.length < 2)
          EmptyState(
            message: 'Log 2+ workouts for this exercise to see the graph.',
            actionLabel: 'Log Workout',
            onAction: widget.onStartWorkout,
          )
        else ...[
          Container(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Semantics(
              label: 'Progress chart for $_selectedExercise',
              child: AppLineChart(dataPoints: dataPoints, unit: unitLabel),
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
          ...historyEntries.reversed.map((entry) {
            final d = entry['date'] as DateTime;
            final wVal = entry['weight'] as double;
            final rVal = entry['reps'] as int;

            return Padding(
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
                      child: Icon(Icons.trending_up_rounded,
                          size: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      formatDate(d),
                      style: typography.body.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    '$wVal $unitLabel × $rVal',
                    style: typography.body
                        .merge(typography.tabularNums)
                        .copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
