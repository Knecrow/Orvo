import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';

class ProfileMetricTile extends StatefulWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool showDivider;

  const ProfileMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  State<ProfileMetricTile> createState() => _ProfileMetricTileState();
}

class _ProfileMetricTileState extends State<ProfileMetricTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() => _pressed = true);
            AppHaptics.light();
          },
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: _pressed ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutCubic,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: _pressed ? colors.surfaceMuted : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    widget.label,
                    style: typography.secondary.copyWith(
                      color: colors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.value,
                    style: typography.body.merge(typography.tabularNums).copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    AppIcons.chevronRight,
                    size: 14,
                    color: colors.textSecondary.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: colors.border.withValues(alpha: 0.6), height: 1),
          ),
      ],
    );
  }
}
