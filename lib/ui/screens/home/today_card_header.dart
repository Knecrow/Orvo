import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/theme/theme_provider.dart';

class TodayCardHeader extends StatelessWidget {
  final Template activeTemplate;
  final List<Template> templates;
  final String weekdayCode;
  final bool isScheduled;
  final bool isLoggedToday;
  final int doneCount;
  final int totalCount;
  final ValueChanged<String> onSelectTemplate;

  const TodayCardHeader({
    super.key,
    required this.activeTemplate,
    required this.templates,
    required this.weekdayCode,
    required this.isScheduled,
    required this.isLoggedToday,
    required this.doneCount,
    required this.totalCount,
    required this.onSelectTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final progress = totalCount > 0 ? (doneCount / totalCount).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top eyebrow & switcher
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isScheduled ? '$weekdayCode · TODAY' : weekdayCode,
              style: typography.label.copyWith(
                color: const Color(0xFF8E8D88),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            if (templates.length > 1)
              PopupMenuButton<String>(
                onSelected: onSelectTemplate,
                color: const Color(0xFFF6F5F0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => templates.map((t) {
                  return PopupMenuItem(
                    value: t.id,
                    child: Text(
                      t.name.toUpperCase(),
                      style: typography.body.copyWith(
                        fontWeight: t.id == activeTemplate.id ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE9E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Switch',
                        style: typography.label.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(Icons.unfold_more_rounded, size: 14, color: colors.textSecondary),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        // Title + Accent dot + completion count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activeTemplate.name.toUpperCase(),
                  style: typography.title.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Text(
              '$doneCount / $totalCount',
              style: typography.secondary
                  .merge(typography.tabularNums)
                  .copyWith(
                    color: isLoggedToday ? colors.textPrimary : const Color(0xFF8E8D88),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4.5,
            backgroundColor: colors.border,
            valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
          ),
        ),
      ],
    );
  }
}

