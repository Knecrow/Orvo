import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/data/app_store.dart';
import '../../../core/data/local_storage.dart';
import '../../../core/models/profile.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';
import '../../components/screen_header.dart';

class SettingsScreen extends StatefulWidget {
  final AppStore store;
  final ValueChanged<AccentColor> onAccentChange;
  final ValueChanged<bool> onHighContrastChange;

  const SettingsScreen({
    super.key,
    required this.store,
    required this.onAccentChange,
    required this.onHighContrastChange,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final profile = widget.store.profile;
    final currentAccent = profile?.accent ?? AccentColor.orange;
    final currentHighContrast = profile?.highContrast ?? false;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Settings',
              scrollOffset: _scrollOffset,
              leftAction: HeaderAction(
                label: 'Back',
                onPress: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.screenHorizontalPadding,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  Text(
                    'APPEARANCE',
                    style: typography.label.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'ACCENT',
                    style: typography.secondary.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: AccentColor.values.map((acc) {
                      final isSelected = acc == currentAccent;
                      final base = AppColors.baseAccents[acc]!;
                      return GestureDetector(
                        onTap: () {
                          AppHaptics.light();
                          widget.onAccentChange(acc);
                          if (profile != null) {
                            widget.store.updateProfile(profile.copyWith(accent: acc));
                          }
                          setState(() {});
                        },
                        child: Container(
                          width: AppLayout.minTouchTarget,
                          height: AppLayout.minTouchTarget,
                          decoration: BoxDecoration(color: base, shape: BoxShape.circle),
                          child: isSelected
                              ? const Icon(AppIcons.check, color: Colors.black, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'High Contrast',
                        style: typography.body.copyWith(color: colors.textPrimary),
                      ),
                      Switch.adaptive(
                        value: currentHighContrast,
                        activeTrackColor: colors.accent,
                        activeThumbColor: colors.buttonLabelOnAccent,
                        inactiveTrackColor: colors.border,
                        inactiveThumbColor: colors.textSecondary,
                        onChanged: (val) {
                          AppHaptics.light();
                          widget.onHighContrastChange(val);
                          if (profile != null) {
                            widget.store.updateProfile(profile.copyWith(highContrast: val));
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'DATA',
                    style: typography.label.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: () {
                      final json = LocalStorage.buildExportJson(
                        widget.store.profile,
                        widget.store.templates,
                        widget.store.workouts,
                        widget.store.bodyEntries,
                      );
                      final todayStr = DateTime.now().toIso8601String().split('T')[0];
                      // ignore: deprecated_member_use
                      Share.share(json, subject: 'orvo-export-$todayStr.json');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Export Data',
                            style: typography.body.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Data is stored only on this device.',
                            style: typography.secondary.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'ABOUT',
                    style: typography.label.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Orvo 1.0.0',
                    style: typography.body.copyWith(color: colors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Local-only gym workout tracker.',
                    style: typography.secondary.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
