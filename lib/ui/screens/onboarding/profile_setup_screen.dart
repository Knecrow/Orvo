import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/body_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';
import '../../components/screen_header.dart';
import '../../components/segmented_control.dart';

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
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  WeightUnit _unit = WeightUnit.kg;
  int _weeklyGoal = 3;

  bool _heightTouched = false;
  bool _weightTouched = false;

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _handleUnitChange(WeightUnit newUnit) {
    if (newUnit != _unit) {
      final curVal = double.tryParse(_weightController.text) ?? 0.0;
      if (curVal > 0) {
        final curKg = inputToKg(curVal, _unit);
        _weightController.text = formatWeightValue(curKg, newUnit);
      }
      setState(() => _unit = newUnit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final name = _nameController.text.trim();
    final heightVal = double.tryParse(_heightController.text) ?? 0.0;
    final isHeightValid = heightVal >= 100.0 && heightVal <= 250.0;
    final heightError = _heightTouched && !isHeightValid ? 'Height must be between 100 and 250 cm.' : null;

    final weightVal = double.tryParse(_weightController.text) ?? 0.0;
    final weightKg = inputToKg(weightVal, _unit);
    final isWeightValid = weightVal > 0 && weightKg >= 20.0 && weightKg <= 400.0;
    final weightError = _weightTouched && !isWeightValid
        ? (_unit == WeightUnit.kg ? 'Weight must be between 20 and 400 kg.' : 'Weight must be between 44 and 880 lb.')
        : null;

    final isFormValid = name.isNotEmpty && isHeightValid && isWeightValid;

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
                      textInputAction: TextInputAction.next,
                      placeholder: 'Alex',
                      onChanged: (_) => setState(() {}),
                    ),
                    Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) setState(() => _heightTouched = true);
                      },
                      child: AppTextInput(
                        label: 'HEIGHT (CM)',
                        controller: _heightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        placeholder: '0',
                        error: heightError,
                        onChanged: (_) => setState(() {}),
                      ),
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
                    Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) setState(() => _weightTouched = true);
                      },
                      child: AppTextInput(
                        label: 'CURRENT WEIGHT (${_unit.name.toUpperCase()})',
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.done,
                        placeholder: '0',
                        error: weightError,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Text('WORKOUT DAYS PER WEEK', style: typography.label.copyWith(color: colors.textSecondary)),
                    const SizedBox(height: AppSpacing.xs),
                    AppSegmentedControl<int>(
                      options: const [
                        SegmentOption(value: 3, label: '3 days'),
                        SegmentOption(value: 4, label: '4 days'),
                        SegmentOption(value: 5, label: '5 days'),
                        SegmentOption(value: 6, label: '6 days'),
                      ],
                      selectedValue: _weeklyGoal,
                      onSelect: (val) => setState(() => _weeklyGoal = val),
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
                    heightCm: heightVal,
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

