import 'package:flutter/cupertino.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';

class FeetInchesWheels extends StatelessWidget {
  final int selectedFeet;
  final int selectedInches;
  final int minFeet;
  final int maxFeet;
  final FixedExtentScrollController feetController;
  final FixedExtentScrollController inchesController;
  final ValueChanged<int> onFeetChanged;
  final ValueChanged<int> onInchesChanged;

  const FeetInchesWheels({
    super.key,
    required this.selectedFeet,
    required this.selectedInches,
    required this.minFeet,
    required this.maxFeet,
    required this.feetController,
    required this.inchesController,
    required this.onFeetChanged,
    required this.onInchesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final feetCount = maxFeet - minFeet + 1;

    return Row(
      children: [
        // Feet wheel
        Expanded(
          flex: 4,
          child: CupertinoPicker.builder(
            scrollController: feetController,
            itemExtent: 40,
            childCount: feetCount,
            onSelectedItemChanged: (idx) {
              AppHaptics.light();
              onFeetChanged(minFeet + idx);
            },
            itemBuilder: (context, idx) {
              final f = minFeet + idx;
              final isSel = f == selectedFeet;
              return Center(
                child: Text(
                  '$f ft',
                  style: typography.body.merge(typography.tabularNums).copyWith(
                    color: isSel ? colors.textPrimary : colors.textSecondary,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                    fontSize: isSel ? 20 : 16,
                  ),
                ),
              );
            },
          ),
        ),
        // Inches wheel
        Expanded(
          flex: 4,
          child: CupertinoPicker.builder(
            scrollController: inchesController,
            itemExtent: 40,
            childCount: 12,
            onSelectedItemChanged: (idx) {
              AppHaptics.light();
              onInchesChanged(idx);
            },
            itemBuilder: (context, idx) {
              final isSel = idx == selectedInches;
              return Center(
                child: Text(
                  '$idx in',
                  style: typography.body.merge(typography.tabularNums).copyWith(
                    color: isSel ? colors.textPrimary : colors.textSecondary,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                    fontSize: isSel ? 20 : 16,
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

