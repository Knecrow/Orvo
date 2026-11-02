import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/screen_header.dart';
import 'body_progress_view.dart';
import 'exercise_progress_view.dart';
import 'overview_dashboard_view.dart';

class ProgressScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onStartWorkout;
  final int initialSubTab;

  const ProgressScreen({
    super.key,
    required this.store,
    required this.onStartWorkout,
    this.initialSubTab = 0,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  late int _activeSubTab;

  static const _subTabs = ['Overview', 'Strength', 'Body Weight'];

  @override
  void initState() {
    super.initState();
    _activeSubTab = widget.initialSubTab;
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void didUpdateWidget(covariant ProgressScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSubTab != widget.initialSubTab) {
      setState(() => _activeSubTab = widget.initialSubTab);
    }
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

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: 'Analytics', scrollOffset: _scrollOffset),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppLayout.screenHorizontalPadding,
              ),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(_subTabs.length, (idx) {
                    final isSel = _activeSubTab == idx;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          AppHaptics.light();
                          setState(() => _activeSubTab = idx);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFF141414)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _subTabs[idx],
                            style: typography.body.copyWith(
                              fontSize: 12.5,
                              fontWeight:
                                  isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel
                                  ? Colors.white
                                  : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppLayout.screenHorizontalPadding,
                  4,
                  AppLayout.screenHorizontalPadding,
                  130,
                ),
                children: [
                  if (_activeSubTab == 0)
                    OverviewDashboardView(
                      store: widget.store,
                      onStartWorkout: widget.onStartWorkout,
                    )
                  else if (_activeSubTab == 1)
                    ExerciseProgressView(
                      store: widget.store,
                      onStartWorkout: widget.onStartWorkout,
                    )
                  else
                    BodyProgressView(store: widget.store),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
