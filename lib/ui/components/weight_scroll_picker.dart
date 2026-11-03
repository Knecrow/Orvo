import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/logic/unit_converter.dart';
import '../../core/models/profile.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';

class WeightScrollPicker extends StatefulWidget {
  final double initialWeight;
  final WeightUnit unit;
  final ValueChanged<double> onSelect;

  const WeightScrollPicker({
    super.key,
    required this.initialWeight,
    required this.unit,
    required this.onSelect,
  });

  @override
  State<WeightScrollPicker> createState() => _WeightScrollPickerState();
}

class _WeightScrollPickerState extends State<WeightScrollPicker> {
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

    final initial = widget.initialWeight > 0 ? widget.initialWeight : (isKg ? 70.0 : 155.0);
    _selectedWhole = initial.floor().clamp(_minWhole, _maxWhole);
    _selectedDecimal = ((initial - _selectedWhole) * 10).round().clamp(0, 9);

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

  double get _currentWeight {
    return _selectedWhole + (_selectedDecimal / 10.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final unitLabel = widget.unit.name;
    final wholeCount = _maxWhole - _minWhole + 1;

    final weightDisplay = formatWeightValue(_currentWeight, widget.unit);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Weight',
                  style: typography.title.copyWith(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$weightDisplay $unitLabel',
                  style: typography.secondary
                      .merge(typography.tabularNums)
                      .copyWith(
                        color: colors.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                AppHaptics.medium();
                widget.onSelect(_currentWeight);
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Done',
                  style: typography.label.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Dual Cupertino Wheels
        SizedBox(
          height: 180,
          child: Row(
            children: [
              // Whole Number Wheel
              Expanded(
                flex: 5,
                child: CupertinoPicker.builder(
                  scrollController: _wholeController,
                  itemExtent: 40,
                  childCount: wholeCount,
                  onSelectedItemChanged: (index) {
                    AppHaptics.light();
                    setState(() {
                      _selectedWhole = _minWhole + index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final val = _minWhole + index;
                    final isSelected = val == _selectedWhole;
                    return Center(
                      child: Text(
                        '$val',
                        style: typography.body
                            .merge(typography.tabularNums)
                            .copyWith(
                              color: isSelected ? colors.textPrimary : colors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              fontSize: isSelected ? 20 : 16,
                            ),
                      ),
                    );
                  },
                ),
              ),
              // Decimal Wheel
              Expanded(
                flex: 3,
                child: CupertinoPicker.builder(
                  scrollController: _decimalController,
                  itemExtent: 40,
                  childCount: 10,
                  onSelectedItemChanged: (index) {
                    AppHaptics.light();
                    setState(() {
                      _selectedDecimal = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedDecimal;
                    return Center(
                      child: Text(
                        '.$index',
                        style: typography.body
                            .merge(typography.tabularNums)
                            .copyWith(
                              color: isSelected ? colors.textPrimary : colors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              fontSize: isSelected ? 20 : 16,
                            ),
                      ),
                    );
                  },
                ),
              ),
              // Unit Label Column
              Container(
                width: 44,
                alignment: Alignment.center,
                child: Text(
                  unitLabel,
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
      ],
    );
  }
}

