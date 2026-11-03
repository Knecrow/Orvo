import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';

class HeightScrollPicker extends StatefulWidget {
  final double initialHeightCm;
  final ValueChanged<double> onSelect;

  const HeightScrollPicker({
    super.key,
    required this.initialHeightCm,
    required this.onSelect,
  });

  @override
  State<HeightScrollPicker> createState() => _HeightScrollPickerState();
}

class _HeightScrollPickerState extends State<HeightScrollPicker> {
  static const int minCm = 100;
  static const int maxCm = 240;

  late int _selectedCm;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final clamped = widget.initialHeightCm.round().clamp(minCm, maxCm);
    _selectedCm = clamped;
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedCm - minCm,
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

    final itemCount = maxCm - minCm + 1;

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
                  'Select Height',
                  style: typography.title.copyWith(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$_selectedCm cm',
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
                widget.onSelect(_selectedCm.toDouble());
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
        // Cupertino Scroll Wheel
        SizedBox(
          height: 180,
          child: CupertinoPicker.builder(
            scrollController: _scrollController,
            itemExtent: 40,
            childCount: itemCount,
            onSelectedItemChanged: (index) {
              AppHaptics.light();
              setState(() {
                _selectedCm = minCm + index;
              });
            },
            itemBuilder: (context, index) {
              final cm = minCm + index;
              final isSelected = cm == _selectedCm;
              return Center(
                child: Text(
                  '$cm cm',
                  style: typography.body
                      .merge(typography.tabularNums)
                      .copyWith(
                        color: isSelected ? colors.textPrimary : colors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        fontSize: isSelected ? 18 : 15,
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

