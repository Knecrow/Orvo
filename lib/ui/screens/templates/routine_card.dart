import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import 'dot_matrix_text.dart';

class RoutineCard extends StatelessWidget {
  final Template template;
  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoutineCard({
    super.key,
    required this.template,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final daysSubtitle = template.days.isNotEmpty
        ? template.days.join('  /  ')
        : 'CUSTOM ROUTINE';

    final items = template.items;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5F0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E1DA),
          width: AppLayout.hairlineWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            AppHaptics.medium();
            onStart();
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Dot Matrix Title + Red Indicator Dot + Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DotMatrixText(
                      text: template.name.toUpperCase(),
                      dotSize: 2.2,
                      spacing: 3.8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onEdit,
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            Icons.more_horiz_rounded,
                            size: 20,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  daysSubtitle,
                  style: typography.label.copyWith(
                    color: const Color(0xFF8E8D88),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                // Exercises Table
                ...items.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final isLast = idx == items.length - 1;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.5),
                        child: Row(
                          children: [
                            // Exercise Name
                            Expanded(
                              flex: 5,
                              child: Text(
                                item.name,
                                style: typography.body.copyWith(
                                  color: const Color(0xFF141414),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Target (sets x reps / duration)
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.target.isNotEmpty ? item.target : '-',
                                textAlign: TextAlign.center,
                                style: typography.secondary.copyWith(
                                  color: const Color(0xFF8E8D88),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            // Load / Weight
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.load.isNotEmpty ? item.load : '-',
                                textAlign: TextAlign.right,
                                style: typography.body
                                    .merge(typography.tabularNums)
                                    .copyWith(
                                      color: item.load == '-' || item.load.isEmpty
                                          ? const Color(0xFF8E8D88)
                                          : const Color(0xFF141414),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Container(
                          height: AppLayout.hairlineWidth,
                          color: const Color(0xFFE4E3DD),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

