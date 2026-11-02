import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

class SwipeableRow extends StatelessWidget {
  final Key itemKey;
  final Widget child;
  final VoidCallback onDelete;
  final bool showSeparator;

  const SwipeableRow({
    required this.itemKey,
    required this.child,
    required this.onDelete,
    this.showSeparator = true,
  }) : super(key: itemKey);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      children: [
        Dismissible(
          key: itemKey,
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDelete(),
          background: Container(
            color: colors.danger,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Text(
              'Delete',
              style: typography.secondary.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: Container(
            color: colors.background,
            width: double.infinity,
            child: child,
          ),
        ),
        if (showSeparator)
          Container(
            height: AppLayout.hairlineWidth,
            margin: const EdgeInsets.only(left: AppLayout.separatorInset),
            color: colors.border,
          ),
      ],
    );
  }
}

