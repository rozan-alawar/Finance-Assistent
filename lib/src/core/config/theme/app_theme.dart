import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_dark.dart';
import 'app_colors_light.dart';

class AppTheme {
  AppTheme._();

  /// Get current app colors based on brightness
  static AppColors colors(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? AppColorsDark() 
        : AppColorsLight();
  }

  /// Get light theme colors
  static AppColors get lightColors => AppColorsLight();

  /// Get dark theme colors
  static AppColors get darkColors => AppColorsDark();

  /// Generate Material ThemeData for light mode
  static ThemeData lightTheme() {
    final colors = AppColorsLight();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
        outline: colors.outline,
        outlineVariant: colors.outlineVariant,
        surfaceTint: colors.surfaceTint,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.textFieldFieldColor,
        hintStyle: TextStyle(color: colors.hintColor),
        prefixIconColor: colors.textFieldPrefixIconColor,
        suffixIconColor: colors.textFieldSuffixIconColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.textFieldFocusBorderColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.customButtonColors.primaryButtonBGColor,
          foregroundColor: colors.customButtonColors.primaryButtonFGColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.customButtonColors.txtButtonColor,
        ),
      ),
    );
  }

  /// Generate Material ThemeData for dark mode
  static ThemeData darkTheme() {
    final colors = AppColorsDark();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryContainer,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
        outline: colors.outline,
        outlineVariant: colors.outlineVariant,
        surfaceTint: colors.surfaceTint,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.textFieldFieldColor,
        hintStyle: TextStyle(color: colors.hintColor),
        prefixIconColor: colors.textFieldPrefixIconColor,
        suffixIconColor: colors.textFieldSuffixIconColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.textFieldFocusBorderColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.customButtonColors.primaryButtonBGColor,
          foregroundColor: colors.customButtonColors.primaryButtonFGColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.customButtonColors.txtButtonColor,
        ),
      ),
    );
  }
}

/// Extension on BuildContext for easy access to colors
extension AppThemeExtension on BuildContext {
  /// Get current app colors
  AppColors get colors => AppTheme.colors(this);
  
  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}