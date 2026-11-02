import 'package:flutter/material.dart';
import '../../core/platform/motion_presets.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

/// Minimal info tile used on the Profile screen.
/// No card border — hierarchy through size and spacing only.
class StatTile extends StatefulWidget {
  final String label;
  final String value;
  final String? unit;
  final Widget? icon;

  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.icon,
  });

  @override
  State<StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<StatTile> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  String _oldValue = '';

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
    _scaleController = AnimationController(
      vsync: this,
      duration: MotionPresets.standard,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 50),
    ]).animate(_scaleController);
  }

  @override
  void didUpdateWidget(StatTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _oldValue) {
      _oldValue = widget.value;
      if (!MotionPresets.isReducedMotion(context)) {
        _scaleController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Semantics(
      label: '${widget.label}: ${widget.value}${widget.unit != null ? ' ${widget.unit}' : ''}',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: typography.label.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(height: AppSpacing.xs),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 4),
                  ],
                  Text(
                    widget.value,
                    style: typography.title.merge(typography.tabularNums).copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (widget.unit != null) ...[
                    const SizedBox(width: 2),
                    Text(
                      widget.unit!,
                      style: typography.secondary.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
