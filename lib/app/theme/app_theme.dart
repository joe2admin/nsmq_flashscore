import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_borders.dart';

class NeoTheme {
  NeoTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: NeoColors.background,
      colorScheme: const ColorScheme.light(
        primary: NeoColors.nsmqRed,
        secondary: NeoColors.nsmqBlue,
        surface: NeoColors.surface,
        error: NeoColors.nsmqBrightRed,
        onPrimary: NeoColors.textLight,
        onSecondary: NeoColors.textLight,
        onSurface: NeoColors.textPrimary,
        onError: NeoColors.textLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NeoColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: NeoTypography.headingLarge(),
        iconTheme: const IconThemeData(color: NeoColors.textPrimary),
      ),
      cardTheme: const CardThemeData(
        color: NeoColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
          borderRadius: NeoBorders.radiusMd,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: NeoColors.border,
        thickness: NeoBorders.strokeDefault,
        space: 1,
      ),
    );
  }
}
