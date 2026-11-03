import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class TargetScrollPicker extends StatefulWidget {
  final String initialTarget;
  final ValueChanged<String> onSelect;

  const TargetScrollPicker({
    super.key,
    required this.initialTarget,
    required this.onSelect,
  });

  @override
  State<TargetScrollPicker> createState() => _TargetScrollPickerState();
}

class _TargetScrollPickerState extends State<TargetScrollPicker> {
  int _tabMode = 0; // 0 = Sets x Reps, 1 = Minutes / Time

  static const _sets = [1, 2, 3, 4, 5, 6, 7, 8, 10];
  static const _reps = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 16, 18, 20, 25, 30];
  static const _timeOptions = [
    '1 min', '2 min', '3 min', '5 min', '8 min', '10 min',
    '12 min', '15 min', '20 min', '25 min', '30 min', '45 min', '60 min',
    '30 sec', '45 sec', '60 sec', '10 each way', '10 each leg'
  ];

  late int _selectedSetIndex;
  late int _selectedRepIndex;
  late int _selectedTimeIndex;

  @override
  void initState() {
    super.initState();
    final raw = widget.initialTarget.trim();

    final xMatch = RegExp(r'(\d+)\s*x\s*(\d+)').firstMatch(raw);
    if (xMatch != null) {
      _tabMode = 0;
      final s = int.tryParse(xMatch.group(1) ?? '3') ?? 3;
      final r = int.tryParse(xMatch.group(2) ?? '10') ?? 10;
      _selectedSetIndex = _sets.contains(s) ? _sets.indexOf(s) : 2;
      _selectedRepIndex = _reps.contains(r) ? _reps.indexOf(r) : 9;
      _selectedTimeIndex = 3;
    } else {
      _tabMode = 1;
      _selectedSetIndex = 2;
      _selectedRepIndex = 9;
      final matchIdx = _timeOptions.indexWhere(
        (t) => t.toLowerCase() == raw.toLowerCase(),
      );
      _selectedTimeIndex = matchIdx != -1 ? matchIdx : 3;
    }
  }

  String _currentResult() {
    if (_tabMode == 0) {
      return '${_sets[_selectedSetIndex]} x ${_reps[_selectedRepIndex]}';
    }
    return _timeOptions[_selectedTimeIndex];
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
            Text('Select Target',
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
        Container(
          height: 38,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tabMode = 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _tabMode == 0 ? const Color(0xFF141414) : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text('Sets × Reps',
                        style: typography.label.copyWith(
                          color: _tabMode == 0 ? Colors.white : colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tabMode = 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _tabMode == 1 ? const Color(0xFF141414) : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text('Minutes / Time',
                        style: typography.label.copyWith(
                          color: _tabMode == 1 ? Colors.white : colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: _tabMode == 0
              ? Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedSetIndex),
                        itemExtent: 38,
                        onSelectedItemChanged: (idx) {
                          AppHaptics.light();
                          setState(() => _selectedSetIndex = idx);
                        },
                        children: _sets
                            .map((s) => Center(
                                child: Text('$s sets',
                                    style: typography.body.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w700))))
                            .toList(),
                      ),
                    ),
                    Text('×',
                        style: typography.title.copyWith(
                            color: colors.textSecondary, fontSize: 20)),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedRepIndex),
                        itemExtent: 38,
                        onSelectedItemChanged: (idx) {
                          AppHaptics.light();
                          setState(() => _selectedRepIndex = idx);
                        },
                        children: _reps
                            .map((r) => Center(
                                child: Text('$r reps',
                                    style: typography.body.copyWith(
                                        color: colors.textPrimary,
                                        fontWeight: FontWeight.w700))))
                            .toList(),
                      ),
                    ),
                  ],
                )
              : CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: _selectedTimeIndex),
                  itemExtent: 38,
                  onSelectedItemChanged: (idx) {
                    AppHaptics.light();
                    setState(() => _selectedTimeIndex = idx);
                  },
                  children: _timeOptions
                      .map((t) => Center(
                          child: Text(t,
                              style: typography.body.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700))))
                      .toList(),
                ),
        ),
      ],
    );
  }
}
