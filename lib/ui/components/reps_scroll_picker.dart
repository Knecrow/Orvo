import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';

class RepsScrollPicker extends StatefulWidget {
  final int initialReps;
  final ValueChanged<int> onSelect;

  const RepsScrollPicker({
    super.key,
    required this.initialReps,
    required this.onSelect,
  });

  @override
  State<RepsScrollPicker> createState() => _RepsScrollPickerState();
}

class _RepsScrollPickerState extends State<RepsScrollPicker> {
  static const int minReps = 1;
  static const int maxReps = 100;

  late int _selectedReps;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedReps = widget.initialReps.clamp(minReps, maxReps);
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedReps - minReps,
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
    final count = maxReps - minReps + 1;

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
                  'Select Reps',
                  style: typography.title.copyWith(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_selectedReps reps',
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
                widget.onSelect(_selectedReps);
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
        SizedBox(
          height: 170,
          child: CupertinoPicker.builder(
            scrollController: _scrollController,
            itemExtent: 40,
            childCount: count,
            onSelectedItemChanged: (index) {
              AppHaptics.light();
              setState(() {
                _selectedReps = minReps + index;
              });
            },
            itemBuilder: (context, index) {
              final r = minReps + index;
              final isSelected = r == _selectedReps;
              return Center(
                child: Text(
                  '$r reps',
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

