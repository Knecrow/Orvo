import 'package:flutter/cupertino.dart';
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

  late int _minWhole;
  late int _maxWhole;
  late int _selectedWhole;
  late int _selectedDecimal;

  late FixedExtentScrollController _wholeController;
  late FixedExtentScrollController _decimalController;

  @override
  void initState() {
    super.initState();
    final isKg = widget.unit == WeightUnit.kg;
    _minWhole = isKg ? 25 : 55;
    _maxWhole = isKg ? 250 : 550;

    _selectedWhole = isKg ? 70 : 155;
    _selectedDecimal = 0;

    _wholeController = FixedExtentScrollController(
      initialItem: _selectedWhole - _minWhole,
    );
    _decimalController = FixedExtentScrollController(
      initialItem: _selectedDecimal,
    );
  }

  @override
  void dispose() {
    _wholeController.dispose();
    _decimalController.dispose();
    super.dispose();
  }

  double get _currentWeight => _selectedWhole + (_selectedDecimal / 10.0);

  void _save() {
    AppHaptics.medium();
    final entry = BodyEntry(
      id: generateId(),
      date: _selectedDate.toIso8601String(),
      weightKg: inputToKg(_currentWeight, widget.unit),
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
    final wholeCount = _maxWhole - _minWhole + 1;

    final weightDisplay = formatWeightValue(_currentWeight, widget.unit);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Log Body Weight',
              style: typography.title.copyWith(color: colors.textPrimary),
            ),
            Text(
              '$weightDisplay ${widget.unit.name}',
              style: typography.title.merge(typography.tabularNums).copyWith(
                color: colors.accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
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
        const SizedBox(height: AppSpacing.md),
        Text(
          'SCROLL TO SELECT WEIGHT ($unitLabel)',
          style: typography.label.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 150,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: CupertinoPicker.builder(
                  scrollController: _wholeController,
                  itemExtent: 38,
                  childCount: wholeCount,
                  onSelectedItemChanged: (index) {
                    AppHaptics.light();
                    setState(() => _selectedWhole = _minWhole + index);
                  },
                  itemBuilder: (context, index) {
                    final val = _minWhole + index;
                    final isSelected = val == _selectedWhole;
                    return Center(
                      child: Text(
                        '$val',
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: isSelected ? colors.textPrimary : colors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          fontSize: isSelected ? 20 : 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: CupertinoPicker.builder(
                  scrollController: _decimalController,
                  itemExtent: 38,
                  childCount: 10,
                  onSelectedItemChanged: (index) {
                    AppHaptics.light();
                    setState(() => _selectedDecimal = index);
                  },
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedDecimal;
                    return Center(
                      child: Text(
                        '.$index',
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: isSelected ? colors.textPrimary : colors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          fontSize: isSelected ? 20 : 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 44,
                alignment: Alignment.center,
                child: Text(
                  widget.unit.name,
                  style: typography.label.copyWith(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Save Weight',
          onPress: _save,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
