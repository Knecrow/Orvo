import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/body_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';
import '../../components/app_text_input.dart';
import '../../components/screen_header.dart';
import '../../components/segmented_control.dart';
import 'bmi_card.dart';

class ProfileScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onOpenSettings;

  const ProfileScreen({
    super.key,
    required this.store,
    required this.onOpenSettings,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  late TextEditingController _nameCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  late WeightUnit _unit;
  late int _weeklyGoal;

  @override
  void initState() {
    super.initState();
    final p = widget.store.profile ?? const Profile(name: '', heightCm: 175, weightKg: 70);
    _unit = p.unit;
    _nameCtrl = TextEditingController(text: p.name);
    _heightCtrl = TextEditingController(text: p.heightCm.toStringAsFixed(0));
    _weightCtrl = TextEditingController(text: formatWeightValue(p.weightKg, _unit));
    _weeklyGoal = p.weeklyGoal;

    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    final p = widget.store.profile;
    if (p == null) return true;
    final wVal = double.tryParse(_weightCtrl.text) ?? 0.0;
    final wKg = inputToKg(wVal, _unit);
    final hVal = double.tryParse(_heightCtrl.text) ?? 0.0;

    return _nameCtrl.text.trim() != p.name ||
        hVal != p.heightCm ||
        (wKg - p.weightKg).abs() > 0.01 ||
        _unit != p.unit ||
        _weeklyGoal != p.weeklyGoal;
  }

  void _save() {
    final wVal = double.tryParse(_weightCtrl.text) ?? 70.0;
    final hVal = double.tryParse(_heightCtrl.text) ?? 175.0;
    final wKg = inputToKg(wVal, _unit);
    final p = widget.store.profile;

    final updated = Profile(
      name: _nameCtrl.text.trim(),
      heightCm: hVal,
      weightKg: wKg,
      unit: _unit,
      weeklyGoal: _weeklyGoal,
      accent: p?.accent ?? AccentColor.orange,
      highContrast: p?.highContrast ?? false,
    );

    widget.store.updateProfile(updated);
    widget.store.saveBodyEntry(BodyEntry(
      id: generateId(),
      date: DateTime.now().toIso8601String(),
      weightKg: wKg,
    ));
    AppHaptics.success();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final currentWeightKg = inputToKg(double.tryParse(_weightCtrl.text) ?? 70.0, _unit);
    final currentHeightCm = double.tryParse(_heightCtrl.text) ?? 175.0;
    final hasChanges = _hasChanges();

    final settingsButton = GestureDetector(
      onTap: widget.onOpenSettings,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: AppLayout.minTouchTarget,
        height: AppLayout.minTouchTarget,
        alignment: Alignment.centerRight,
        child: Icon(AppIcons.settings, size: 22, color: colors.textSecondary),
      ),
    );

    final rightWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasChanges) ...[
          GestureDetector(
            onTap: _save,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Save',
              style: typography.body.copyWith(
                color: colors.accentText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        settingsButton,
      ],
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'Profile',
              scrollOffset: _scrollOffset,
              rightWidget: rightWidget,
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(AppLayout.screenHorizontalPadding, 0, AppLayout.screenHorizontalPadding, 100),
                children: [
                  AppTextInput(label: 'NAME', controller: _nameCtrl, onChanged: (_) => setState(() {})),
                  AppTextInput(
                    label: 'HEIGHT (CM)',
                    controller: _heightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                  Text('UNIT', style: typography.label.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  AppSegmentedControl<WeightUnit>(
                    options: const [SegmentOption(value: WeightUnit.kg, label: 'kg'), SegmentOption(value: WeightUnit.lb, label: 'lb')],
                    selectedValue: _unit,
                    onSelect: (u) {
                      final cur = double.tryParse(_weightCtrl.text) ?? 0.0;
                      if (cur > 0) _weightCtrl.text = formatWeightValue(inputToKg(cur, _unit), u);
                      setState(() => _unit = u);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextInput(
                    label: 'WEIGHT (${_unit.name.toUpperCase()})',
                    controller: _weightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                  ),
                  Text('WORKOUT DAYS PER WEEK', style: typography.label.copyWith(color: colors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  AppSegmentedControl<int>(
                    options: const [SegmentOption(value: 3, label: '3 days'), SegmentOption(value: 4, label: '4 days'), SegmentOption(value: 5, label: '5 days'), SegmentOption(value: 6, label: '6 days')],
                    selectedValue: _weeklyGoal,
                    onSelect: (g) => setState(() => _weeklyGoal = g),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BmiCard(weightKg: currentWeightKg, heightCm: currentHeightCm),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
