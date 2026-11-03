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
import '../../components/app_button.dart';
import '../../components/app_scroll_picker_field.dart';
import '../../components/app_text_input.dart';
import '../../components/days_per_week_scroll_picker.dart';
import '../../components/height_scroll_picker.dart';
import '../../components/screen_header.dart';
import '../../components/segmented_control.dart';
import '../../components/weight_scroll_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onComplete;

  const ProfileSetupScreen({
    super.key,
    required this.store,
    required this.onComplete,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  double _heightCm = 175.0;
  double _weightVal = 70.0;
  WeightUnit _unit = WeightUnit.kg;
  int _weeklyGoal = 3;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleUnitChange(WeightUnit newUnit) {
    if (newUnit != _unit) {
      final curKg = inputToKg(_weightVal, _unit);
      final converted = kgToUnit(curKg, newUnit);
      setState(() {
        _unit = newUnit;
        _weightVal = converted;
      });
    }
  }

  void _openHeightPicker() {
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.42,
      child: HeightScrollPicker(
        initialHeightCm: _heightCm,
        onSelect: (val) => setState(() => _heightCm = val),
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

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final name = _nameController.text.trim();
    final weightKg = inputToKg(_weightVal, _unit);
    final isFormValid = name.isNotEmpty && _heightCm > 0 && weightKg > 0;
    final weightDisplay = '${formatWeightValue(_weightVal, _unit)} ${_unit.name}';
    final daysDisplay = '$_weeklyGoal ${_weeklyGoal == 1 ? 'day' : 'days'} / week';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Profile'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenHorizontalPadding),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextInput(
                      label: 'NAME',
                      controller: _nameController,
                      autoFocus: true,
                      autoCorrect: false,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      placeholder: 'Alex',
                      onChanged: (_) => setState(() {}),
                    ),
                    AppScrollPickerField(
                      label: 'HEIGHT (CM)',
                      value: '${_heightCm.round()} cm',
                      onTap: _openHeightPicker,
                    ),
                    Text('UNIT', style: typography.label.copyWith(color: colors.textSecondary)),
                    const SizedBox(height: AppSpacing.xs),
                    AppSegmentedControl<WeightUnit>(
                      options: const [
                        SegmentOption(value: WeightUnit.kg, label: 'kg'),
                        SegmentOption(value: WeightUnit.lb, label: 'lb'),
                      ],
                      selectedValue: _unit,
                      onSelect: _handleUnitChange,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppScrollPickerField(
                      label: 'CURRENT WEIGHT (${_unit.name.toUpperCase()})',
                      value: weightDisplay,
                      onTap: _openWeightPicker,
                    ),
                    AppScrollPickerField(
                      label: 'WORKOUT DAYS PER WEEK',
                      value: daysDisplay,
                      onTap: _openDaysPerWeekPicker,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppLayout.screenHorizontalPadding),
              child: AppButton(
                label: 'Continue',
                disabled: !isFormValid,
                onPress: () {
                  final profile = Profile(
                    name: name,
                    heightCm: _heightCm,
                    weightKg: weightKg,
                    unit: _unit,
                    weeklyGoal: _weeklyGoal,
                    accent: AccentColor.orange,
                    highContrast: false,
                  );
                  final initialEntry = BodyEntry(
                    id: generateId(),
                    date: DateTime.now().toIso8601String(),
                    weightKg: weightKg,
                  );
                  widget.store.updateProfile(profile);
                  widget.store.saveBodyEntry(initialEntry);
                  AppHaptics.success();
                  widget.onComplete();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
