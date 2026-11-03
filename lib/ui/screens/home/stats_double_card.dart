import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';

class StatsDoubleCard extends StatelessWidget {
  final int streak;
  final String weightStr;
  final String unitLabel;
  final VoidCallback onStreakTap;
  final VoidCallback onWeightTap;

  const StatsDoubleCard({
    super.key,
    required this.streak,
    required this.weightStr,
    required this.unitLabel,
    required this.onStreakTap,
    required this.onWeightTap,
  });

  Widget _buildCompactPill({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Expanded(
      child: _PressablePill(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 0.8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: typography.secondary.merge(typography.tabularNums).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                AppIcons.chevronRight,
                size: 12,
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCompactPill(
          context: context,
          icon: AppIcons.flame,
          iconColor: AppTheme.of(context).colors.accent,
          text: '$streak',
          onTap: onStreakTap,
        ),
        const SizedBox(width: 10),
        _buildCompactPill(
          context: context,
          icon: AppIcons.activity,
          iconColor: AppTheme.of(context).colors.textSecondary,
          text: '$weightStr $unitLabel',
          onTap: onWeightTap,
        ),
      ],
    );
  }
}

class _PressablePill extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressablePill({required this.child, required this.onTap});

  @override
  State<_PressablePill> createState() => _PressablePillState();
}

class _PressablePillState extends State<_PressablePill> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        AppHaptics.light();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
