This is a Flutter mobile application for "Orvo", a gym workout tracker. Prioritize mobile-first patterns, performance, and cross-platform fidelity.

## Commands

Always prepend Flutter to PATH: `$env:PATH = "C:\src\flutter\bin;$env:PATH"`

```bash
flutter test               # run unit tests
flutter analyze            # run static analyzer
flutter run                # run app on device / emulator / windows
```

## Craft & Architecture Standards

- Single responsibility per file, files kept under 250 lines.
- No third-party bloat: custom bottom sheets, custom snackbars, custom headers, custom segmented controls.
- Theme tokens: strict colors, dark/light with computed contrast ratios, Inter typography.
- Tabular figures for numbers, accurate 1-decimal weights with stripped `.0`.
- Pure logic isolated and unit tested.
