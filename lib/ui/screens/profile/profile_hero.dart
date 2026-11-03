import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';
import '../../components/profile_avatar.dart';

class ProfileHero extends StatelessWidget {
  final TextEditingController nameController;
  final int weeklyGoal;
  final ValueChanged<String> onNameChanged;

  const ProfileHero({
    super.key,
    required this.nameController,
    required this.weeklyGoal,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        ProfileAvatar(
          name: nameController.text,
          size: 78,
          showAccentRing: true,
          onTap: () => AppHaptics.light(),
        ),
        const SizedBox(height: AppSpacing.md),
        IntrinsicWidth(
          child: TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            cursorColor: colors.accent,
            style: typography.title.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
            decoration: InputDecoration(
              hintText: 'Your Name',
              hintStyle: typography.title.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              isDense: true,
            ),
            onChanged: onNameChanged,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border, width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.flame, size: 12, color: colors.accent),
              const SizedBox(width: 5),
              Text(
                '$weeklyGoal DAYS / WEEK',
                style: typography.label.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
