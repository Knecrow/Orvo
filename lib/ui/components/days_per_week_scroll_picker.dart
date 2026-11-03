import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';

class DaysPerWeekScrollPicker extends StatefulWidget {
  final int initialDays;
  final ValueChanged<int> onSelect;

  const DaysPerWeekScrollPicker({
    super.key,
    required this.initialDays,
    required this.onSelect,
  });

  @override
  State<DaysPerWeekScrollPicker> createState() => _DaysPerWeekScrollPickerState();
}

class _DaysPerWeekScrollPickerState extends State<DaysPerWeekScrollPicker> {
  static const int minDays = 1;
  static const int maxDays = 7;

  late int _selectedDays;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialDays.clamp(minDays, maxDays);
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedDays - minDays,
    );
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
    final count = maxDays - minDays + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Days Per Week',
                  style: typography.title.copyWith(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_selectedDays ${_selectedDays == 1 ? 'day' : 'days'} per week',
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
                widget.onSelect(_selectedDays);
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
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
        SizedBox(
          height: 170,
          child: CupertinoPicker.builder(
            scrollController: _scrollController,
            itemExtent: 40,
            childCount: count,
            onSelectedItemChanged: (index) {
              AppHaptics.light();
              setState(() {
                _selectedDays = minDays + index;
              });
            },
            itemBuilder: (context, index) {
              final d = minDays + index;
              final isSelected = d == _selectedDays;
              return Center(
                child: Text(
                  '$d ${d == 1 ? 'day' : 'days'} / week',
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
      ],
    );
  }
}

