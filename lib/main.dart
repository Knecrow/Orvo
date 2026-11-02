import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/data/app_store.dart';
import 'core/models/profile.dart';
import 'core/theme/colors.dart';
import 'core/theme/theme_provider.dart';
import 'ui/screens/main_shell.dart';
import 'ui/screens/onboarding/profile_setup_screen.dart';
import 'ui/screens/onboarding/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OrvoApp());
}

class OrvoApp extends StatefulWidget {
  const OrvoApp({super.key});

  @override
  State<OrvoApp> createState() => _OrvoAppState();
}

class _OrvoAppState extends State<OrvoApp> {
  final AppStore _store = AppStore();
  AccentColor? _previewAccent;
  bool? _previewHighContrast;
  bool? _previewIsDark;
  int _onboardingStep = 0; // 0 = welcome, 1 = setup

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        if (!_store.isHydrated) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(backgroundColor: Color(0xFFE6E5E0)),
          );
        }

        // Default to the warm stone / oatmeal design aesthetic matching the reference UI
        final isDark = _previewIsDark ?? false;
        final profile = _store.profile;

        final activeAccent = _previewAccent ?? profile?.accent ?? AccentColor.orange;
        final activeHighContrast = _previewHighContrast ?? profile?.highContrast ?? false;

        final resolvedColors = AppColors.resolve(
          isDark: isDark,
          accent: activeAccent,
          highContrast: activeHighContrast,
        );

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: resolvedColors.background,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );

        Widget currentScreen;
        if (profile == null) {
          if (_onboardingStep == 0) {
            currentScreen = WelcomeScreen(
              key: const ValueKey('WelcomeScreen'),
              onContinue: () => setState(() => _onboardingStep = 1),
            );
          } else {
            currentScreen = ProfileSetupScreen(
              key: const ValueKey('ProfileSetupScreen'),
              store: _store,
              onComplete: () => setState(() {}),
            );
          }
        } else {
          currentScreen = MainShell(
            key: const ValueKey('MainShell'),
            store: _store,
            onAccentChange: (acc) => setState(() => _previewAccent = acc),
            onHighContrastChange: (hc) => setState(() => _previewHighContrast = hc),
          );
        }

        return AppTheme(
          isDark: isDark,
          accent: activeAccent,
          highContrast: activeHighContrast,
          child: MaterialApp(
            title: 'Orvo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: resolvedColors.background,
              colorScheme: ColorScheme.fromSeed(
                seedColor: resolvedColors.accent,
                brightness: isDark ? Brightness.dark : Brightness.light,
                surface: resolvedColors.surface,
              ),
            ),
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: currentScreen,
            ),
          ),
        );
      },
    );
  }
}
