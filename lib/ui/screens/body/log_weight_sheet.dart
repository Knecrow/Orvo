import 'package:flutter/material.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/body_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';

class LogWeightSheet extends StatefulWidget {
  final WeightUnit unit;
  final ValueChanged<BodyEntry> onSave;

  const LogWeightSheet({
    super.key,
    required this.unit,
    required this.onSave,
  });

  @override
  State<LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends State<LogWeightSheet> {
  DateTime _selectedDate = DateTime.now();
  final _weightCtrl = TextEditingController();
  bool _touched = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  bool _isValid() {
    final val = double.tryParse(_weightCtrl.text) ?? 0.0;
    final kg = inputToKg(val, widget.unit);
    return val > 0 && kg >= 20.0 && kg <= 400.0;
  }

  void _save() {
    if (!_isValid()) return;
    AppHaptics.medium();
    final val = double.parse(_weightCtrl.text);
    final entry = BodyEntry(
      id: generateId(),
      date: _selectedDate.toIso8601String(),
      weightKg: inputToKg(val, widget.unit),
    );
    widget.onSave(entry);
    AppHaptics.success();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final unitLabel = widget.unit.name.toUpperCase();

    final error = _touched && !_isValid()
        ? (widget.unit == WeightUnit.kg ? 'Weight must be between 20 and 400 kg.' : 'Weight must be between 44 and 880 lb.')
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Log Body Weight',
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('DATE', style: typography.label.copyWith(color: colors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
          child: Container(
            height: AppLayout.minTouchTarget,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            alignment: Alignment.centerLeft,
            child: Text(
              formatDate(_selectedDate),
              style: typography.body.copyWith(color: colors.textPrimary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Focus(
          onFocusChange: (f) {
            if (!f) setState(() => _touched = true);
          },
          child: AppTextInput(
            label: 'WEIGHT ($unitLabel)',
            controller: _weightCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            placeholder: '0',
            autoFocus: true,
            error: error,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
          ),
        ),
        AppButton(
          label: 'Save',
          disabled: !_isValid(),
          onPress: _save,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

