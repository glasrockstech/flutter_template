import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// Central place to build the app's ThemeData using FlexColorScheme.
class AppTheme {
  const AppTheme._();

  /// Light theme.
  static ThemeData light({FlexSchemeColor? colors}) {
    return FlexThemeData.light(
      scheme: FlexScheme.blue,
      colors: colors,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(
        defaultRadius: 12,
        elevatedButtonRadius: 12,
        outlinedButtonRadius: 12,
        filledButtonRadius: 12,
        cardRadius: 12,
        dialogRadius: 16,
        inputDecoratorRadius: 12,
      ),
      visualDensity: VisualDensity.standard,
      typography: Typography.material2021(),
    );
  }

  /// Dark theme.
  static ThemeData dark({FlexSchemeColor? colors}) {
    return FlexThemeData.dark(
      scheme: FlexScheme.blue,
      colors: colors,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(
        defaultRadius: 12,
        elevatedButtonRadius: 12,
        outlinedButtonRadius: 12,
        filledButtonRadius: 12,
        cardRadius: 12,
        dialogRadius: 16,
        inputDecoratorRadius: 12,
      ),
      visualDensity: VisualDensity.standard,
      typography: Typography.material2021(),
    );
  }
}

