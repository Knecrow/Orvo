import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/app_line_chart.dart';
import '../../components/screen_header.dart';
import '../../components/swipeable_row.dart';
import 'log_weight_sheet.dart';

class BodyScreen extends StatefulWidget {
  final AppStore store;

  const BodyScreen({super.key, required this.store});

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final store = widget.store;

    final unit = store.profile?.unit ?? WeightUnit.kg;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';
    final entries = store.bodyEntries;

    final currentWeightKg = entries.isNotEmpty
        ? entries.first.weightKg
        : store.profile?.weightKg ?? 70.0;
    final currentWeightStr = formatWeightValue(currentWeightKg, unit);

    final chartPoints = entries.reversed.map((e) {
      final date = DateTime.tryParse(e.date) ?? DateTime.now();
      final val = kgToUnit(e.weightKg, unit);
      return ChartDataPoint(
        date: date,
        value: (val * 10).round() / 10,
        label: formatDate(date),
      );
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: 'Body', scrollOffset: _scrollOffset),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppLayout.screenHorizontalPadding,
                  0,
                  AppLayout.screenHorizontalPadding,
                  130,
                ),
                children: [
                  // Hero dark card with big weight + chart
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              currentWeightStr,
                              style: typography.largeTitle.merge(typography.tabularNums).copyWith(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              unitLabel,
                              style: typography.body.copyWith(
                                color: const Color(0xFF888884),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current weight',
                          style: typography.secondary.copyWith(color: const Color(0xFF888884)),
                        ),
                        const SizedBox(height: 16),
                        if (chartPoints.length >= 2) ...[
                          Semantics(
                            label: 'Body weight chart, ${chartPoints.length} entries',
                            child: AppLineChart(dataPoints: chartPoints, unit: unitLabel),
                          ),
                        ] else
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Log at least 2 entries to see chart.',
                              style: TextStyle(color: Color(0xFF888884), fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Log Body Weight',
                    variant: ButtonVariant.primary,
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
                  const SizedBox(height: AppSpacing.xl),
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
                                child: Icon(
                                  Icons.monitor_weight_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: typography.body.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
