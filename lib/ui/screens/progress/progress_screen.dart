import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/screen_header.dart';
import 'overview_dashboard_view.dart';

class ProgressScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onStartWorkout;

  const ProgressScreen({
    super.key,
    required this.store,
    required this.onStartWorkout,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
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

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: 'Analytics', scrollOffset: _scrollOffset),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppLayout.screenHorizontalPadding,
                  AppSpacing.xs,
                  AppLayout.screenHorizontalPadding,
                  130,
                ),
                children: [
                  OverviewDashboardView(
                    store: widget.store,
                    onStartWorkout: widget.onStartWorkout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
