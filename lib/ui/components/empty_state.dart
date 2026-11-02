import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';
import 'app_button.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: typography.body.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.left,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: actionLabel!,
              onPress: onAction,
              variant: ButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }
}

