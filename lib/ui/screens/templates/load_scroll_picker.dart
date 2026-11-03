import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class LoadScrollPicker extends StatefulWidget {
  final String initialLoad;
  final ValueChanged<String> onSelect;

  const LoadScrollPicker({
    super.key,
    required this.initialLoad,
    required this.onSelect,
  });

  @override
  State<LoadScrollPicker> createState() => _LoadScrollPickerState();
}

class _LoadScrollPickerState extends State<LoadScrollPicker> {
  int _mode = 0; // 0 = Weight, 1 = Body, 2 = None (-)

  static const _weightValues = [
    '2-3', '3-4', '5-6', '6-8', '10-15', '15-20', '25-30', '30-40',
    '2.5', '5', '7.5', '10', '12', '14', '15', '17.5', '20', '22.5', '25',
    '30', '35', '40', '45', '50', '55', '60', '65', '70', '75', '80',
    '85', '90', '95', '100', '110', '120', '130', '140', '150', '160', '180', '200'
  ];

  static const _units = ['kg', 'kg each', 'lb', 'lb each'];

  late int _selectedWeightIndex;
  late int _selectedUnitIndex;

  @override
  void initState() {
    super.initState();
    final raw = widget.initialLoad.trim();

    if (raw == 'Body' || raw.toLowerCase() == 'bodyweight') {
      _mode = 1;
      _selectedWeightIndex = 18; // 25
      _selectedUnitIndex = 0;
    } else if (raw == '-' || raw.isEmpty) {
      _mode = 2;
      _selectedWeightIndex = 18;
      _selectedUnitIndex = 0;
    } else {
      _mode = 0;
      // Find matching unit
      var matchedUnitIdx = 0;
      for (int i = 0; i < _units.length; i++) {
        if (raw.endsWith(_units[i])) {
          matchedUnitIdx = i;
          break;
        }
      }
      _selectedUnitIndex = matchedUnitIdx;

      // Extract weight part
      final weightPart = raw.replaceAll(_units[matchedUnitIdx], '').trim();
      _selectedWeightIndex = _weightValues.contains(weightPart)
          ? _weightValues.indexOf(weightPart)
          : 18;
    }
  }

  String _currentResult() {
    if (_mode == 1) return 'Body';
    if (_mode == 2) return '-';
    return '${_weightValues[_selectedWeightIndex]} ${_units[_selectedUnitIndex]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select Load / Weight',
                style: typography.title.copyWith(color: colors.textPrimary)),
            GestureDetector(
              onTap: () {
                AppHaptics.medium();
                widget.onSelect(_currentResult());
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Done',
                    style: typography.label.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Mode Selector: Weight, Body, None
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mode = 0),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mode == 0 ? const Color(0xFF141414) : colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text('Weight',
                      style: typography.label.copyWith(
                        color: _mode == 0 ? Colors.white : colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mode = 1),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mode == 1 ? const Color(0xFF141414) : colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text('Bodyweight',
                      style: typography.label.copyWith(
                        color: _mode == 1 ? Colors.white : colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mode = 2),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: _mode == 2 ? const Color(0xFF141414) : colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text('None (-)',
                      style: typography.label.copyWith(
                        color: _mode == 2 ? Colors.white : colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: _mode == 0
              ? Row(
                  children: [
                    // Weight Wheel
                    Expanded(
                      flex: 5,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedWeightIndex),
                        itemExtent: 38,
                        onSelectedItemChanged: (idx) {
                          AppHaptics.light();
                          setState(() => _selectedWeightIndex = idx);
                        },
                        children: _weightValues
                            .map((w) => Center(
                                child: Text(w,
                                    style: typography.body.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16))))
                            .toList(),
                      ),
                    ),
                    // Unit Wheel
                    Expanded(
                      flex: 4,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedUnitIndex),
                        itemExtent: 38,
                        onSelectedItemChanged: (idx) {
                          AppHaptics.light();
                          setState(() => _selectedUnitIndex = idx);
                        },
                        children: _units
                            .map((u) => Center(
                                child: Text(u,
                                    style: typography.body.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15))))
                            .toList(),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    _mode == 1 ? 'Bodyweight (Body)' : 'No Weight (-)',
                    style: typography.title.copyWith(
                      color: colors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
