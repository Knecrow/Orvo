import 'package:flutter/material.dart';
import '../../../core/theme/theme_provider.dart';

class TodayBottomAction extends StatelessWidget {
  final bool isLoggedToday;
  final int doneCount;
  final int totalCount;
  final VoidCallback onFinish;

  const TodayBottomAction({
    super.key,
    required this.isLoggedToday,
    required this.doneCount,
    required this.totalCount,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    if (isLoggedToday) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        decoration: BoxDecoration(
          color: colors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, size: 16, color: colors.accent),
            const SizedBox(width: 8),
            Text(
              'Completed',
              style: typography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final hasChecked = doneCount > 0;
    return GestureDetector(
      onTap: onFinish,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: hasChecked ? colors.accent : colors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          hasChecked ? 'Finish ($doneCount/$totalCount)' : 'Start Workout',
          style: typography.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
