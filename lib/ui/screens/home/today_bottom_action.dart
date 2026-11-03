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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0x152E7D32),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x352E7D32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF2E7D32)),
            const SizedBox(width: 6),
            Text(
              'Workout completed today!',
              style: typography.body.copyWith(
                color: const Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
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
          color: hasChecked ? colors.accent : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          hasChecked ? 'Finish Workout ($doneCount/$totalCount done)' : 'Log Full Workout',
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

