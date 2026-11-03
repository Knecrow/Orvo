import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/body_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_icons.dart';
import '../../components/days_per_week_scroll_picker.dart';
import '../../components/height_scroll_picker.dart';
import '../../components/screen_header.dart';
import '../../components/weight_scroll_picker.dart';
import 'bmi_card.dart';
import 'profile_hero.dart';
import 'profile_metrics_card.dart';
import 'profile_save_bar.dart';

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
  late double _heightCm;
  late bool _useFeet;
  late double _weightVal;
  late WeightUnit _unit;
  late int _weeklyGoal;

  @override
  void initState() {
    super.initState();
    final p = widget.store.profile ?? const Profile(name: '', heightCm: 175, weightKg: 70);
    _unit = p.unit;
    _useFeet = p.unit == WeightUnit.lb;
    _nameCtrl = TextEditingController(text: p.name);
    _heightCm = p.heightCm > 0 ? p.heightCm : 175.0;
    _weightVal = kgToUnit(p.weightKg, _unit);
    _weeklyGoal = p.weeklyGoal;
    _scrollController.addListener(() => setState(() => _scrollOffset = _scrollController.offset));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    final p = widget.store.profile;
    if (p == null) return true;
    final wKg = inputToKg(_weightVal, _unit);
    return _nameCtrl.text.trim() != p.name ||
        (_heightCm - p.heightCm).abs() > 0.1 ||
        (wKg - p.weightKg).abs() > 0.05 ||
        _unit != p.unit ||
        _weeklyGoal != p.weeklyGoal;
  }

  void _save() {
    final wKg = inputToKg(_weightVal, _unit);
    final p = widget.store.profile;
    final updated = Profile(
      name: _nameCtrl.text.trim(),
      heightCm: _heightCm,
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

  void _openHeightPicker() {
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.44,
      child: HeightScrollPicker(
        initialHeightCm: _heightCm,
        initialUseFeet: _useFeet,
        onSelect: (val, useFeet) => setState(() {
          _heightCm = val;
          _useFeet = useFeet;
        }),
      ),
    );
  }

  void _openWeightPicker() {
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.42,
      child: WeightScrollPicker(
        initialWeight: _weightVal,
        unit: _unit,
        onSelect: (val) => setState(() => _weightVal = val),
      ),
    );
  }

  void _openDaysPerWeekPicker() {
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.40,
      child: DaysPerWeekScrollPicker(
        initialDays: _weeklyGoal,
        onSelect: (val) => setState(() => _weeklyGoal = val),
      ),
    );
  }

  void _handleUnitChange(WeightUnit u) {
    if (u == _unit) return;
    final currentKg = inputToKg(_weightVal, _unit);
    setState(() {
      _unit = u;
      _weightVal = kgToUnit(currentKg, u);
      _useFeet = u == WeightUnit.lb;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final currentWeightKg = inputToKg(_weightVal, _unit);
    final hasChanges = _hasChanges();
    final weightDisplay = '${formatWeightValue(_weightVal, _unit)} ${_unit.name}';
    final heightDisplay = formatHeight(_heightCm, useFeet: _useFeet);
    final daysDisplay = '$_weeklyGoal ${_weeklyGoal == 1 ? 'day' : 'days'} / wk';

    final rightWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasChanges) ...[
          GestureDetector(
            onTap: _save,
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Save',
              style: typography.body.copyWith(color: colors.accentText, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        GestureDetector(
          onTap: widget.onOpenSettings,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: AppLayout.minTouchTarget,
            height: AppLayout.minTouchTarget,
            alignment: Alignment.centerRight,
            child: Icon(AppIcons.settings, size: 22, color: colors.textSecondary),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                ScreenHeader(title: 'Profile', scrollOffset: _scrollOffset, rightWidget: rightWidget),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppLayout.screenHorizontalPadding,
                      0,
                      AppLayout.screenHorizontalPadding,
                      130,
                    ),
                    children: [
                      ProfileHero(
                        nameController: _nameCtrl,
                        weeklyGoal: _weeklyGoal,
                        onNameChanged: (_) => setState(() {}),
                      ),
                      ProfileMetricsCard(
                        heightDisplay: heightDisplay,
                        weightDisplay: weightDisplay,
                        daysDisplay: daysDisplay,
                        unit: _unit,
                        onHeightTap: _openHeightPicker,
                        onWeightTap: _openWeightPicker,
                        onDaysTap: _openDaysPerWeekPicker,
                        onUnitChange: _handleUnitChange,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      BmiCard(weightKg: currentWeightKg, heightCm: _heightCm),
                    ],
                  ),
                ),
              ],
            ),
            ProfileSaveBar(isVisible: hasChanges, onSave: _save),
          ],
        ),
      ),
    );
  }
}
