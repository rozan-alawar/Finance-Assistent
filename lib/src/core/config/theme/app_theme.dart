import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_color/app_colors.dart';
import 'app_color/app_colors_dark.dart';
import 'app_color/app_colors_light.dart';
import 'app_color/extensions_color.dart' as ex;

/// App theme mode enumeration
enum AppThemeMode {
  light,
  dark;

  const AppThemeMode();

  ThemeData get _baseTheme {
    return switch (this) {
      AppThemeMode.light => ThemeData.light(),
      AppThemeMode.dark => ThemeData.dark(),
    };
  }

  AppColors get _colorsPalette {
    return switch (this) {
      AppThemeMode.light => AppColorsLight(),
      AppThemeMode.dark => AppColorsDark(),
    };
  }

  Brightness get _colorSchemeBrightness {
    return switch (this) {
      AppThemeMode.light => Brightness.light,
      AppThemeMode.dark => Brightness.dark,
    };
  }

  ThemeData getThemeData(String fontFamily) {
    return AppTheme(themeMode: this).getThemeData(fontFamily);
  }
}

/// Main theme configuration class
class AppTheme {
  AppTheme({required AppThemeMode themeMode}) : _themeMode = themeMode;

  final AppThemeMode _themeMode;

  late final ThemeData _baseTheme = _themeMode._baseTheme;

  late final Brightness _colorSchemeBrightness =
      _themeMode._colorSchemeBrightness;

  late final AppColors _appColors = _themeMode._colorsPalette;

  late final Color _background = _appColors.background;

  late final Color _scaffoldBackgroundColor = _appColors.background;

  late final ex.ButtonColors _customButtonColors =
      _appColors.customButtonColors;

  late final ex.GradientColors _gradientColors = _appColors.gradientColors;

  late final ex.SwitcherColors _switcherColors = _appColors.switcherColors;

  late final ex.TextFieldColors _textFieldColors = _appColors.textFieldColors;

  late final ex.CommonUIColors _commonUIColors = _appColors.commonUIColors;

  late final _inputDecorationTheme = InputDecorationTheme(
    isDense: true,
    filled: true,
    errorMaxLines: 2,
    fillColor: _appColors.textFieldFieldColor,
    suffixIconColor: _appColors.textFieldSuffixIconColor,
    prefixIconColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused)
          ? _appColors.textFieldFocusBorderColor
          : _appColors.textFieldPrefixIconColor,
    ),
    hintStyle: TextStyle(
      color: _appColors.hintColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    errorStyle: TextStyle(
      color: _appColors.error,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: _appColors.outline),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _appColors.outline),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: _appColors.textFieldFocusBorderColor,
        width: 2,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _appColors.error),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _appColors.error, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(12)),

    ),

  );

  late final _checkboxTheme = CheckboxThemeData(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 18,
    side: WidgetStateBorderSide.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(
          color: _appColors.switcherColors.neutralColors.shade40,
        );
      }
      if (states.contains(WidgetState.selected)) {
        return BorderSide(color: _appColors.primary);
      }
      return BorderSide(color: _appColors.switcherColors.neutralColors.shade60);
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      final surface = _appColors.surface;
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _appColors.switcherColors.neutralColors.shade50;
        }
        return surface;
      }
      if (states.contains(WidgetState.selected)) {
        return _appColors.primary;
      }
      return surface;
    }),
    checkColor: WidgetStateProperty.all(_appColors.onPrimary),
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed) ||
          states.contains(WidgetState.focused)) {
        return _appColors.primary.withOpacity(.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return _appColors.primary.withOpacity(.08);
      }
      return null;
    }),
  );

  late final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
        height: 60,
        backgroundColor: _appColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return Colors.transparent;
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: _appColors.primary, size: 24);
          }
          return IconThemeData(
            color: _appColors.onSurface.withOpacity(0.6),
            size: 24,
          );
        }),

        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: _appColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: _appColors.tertiaryFixed,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          );
        }),
        elevation: 0,
      );

  late final expansionTileThemeData = ExpansionTileThemeData(
    textColor: _appColors.onSurface,
    iconColor: _appColors.primary,
    collapsedTextColor: _appColors.onSurface,
    expandedAlignment: Alignment.topRight,
    collapsedIconColor: _appColors.primary,
    backgroundColor: _appColors.expansionTileColor,
    collapsedBackgroundColor: _appColors.expansionTileColor,
    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
    expansionAnimationStyle: AnimationStyle(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.transparent),
    ),
    collapsedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.transparent),
    ),
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  );

  ThemeData getThemeData(String fontFamily) {
    return _baseTheme.copyWith(
      textTheme: _colorSchemeBrightness.toTypography(fontFamily),
      primaryColor: _appColors.primary,
      colorScheme: ColorScheme(
        brightness: _colorSchemeBrightness,
        primaryFixed: _appColors.seedColor,
        primary: _appColors.primary,
        onPrimary: _appColors.onPrimary,
        secondary: _appColors.secondary,
        onSecondary: _appColors.onSecondary,
        error: _appColors.error,
        onError: _appColors.onPrimary,
        surface: _appColors.surface,
        surfaceTint: _appColors.surfaceTint,
        onSurface: _appColors.onSurface,
        surfaceDim: _appColors.onSurfaceDim,
        surfaceBright: _appColors.surfaceBright,
        outline: _appColors.outline,
        outlineVariant: _appColors.outlineVariant,
        surfaceContainer: _appColors.surfaceContainer,
        primaryContainer: _appColors.primaryContainer,
        tertiaryFixed: _appColors.tertiaryFixed,
        secondaryContainer: _appColors.secondaryLight,
        surfaceContainerHighest: _appColors.surfaceContainerHighest,
        surfaceContainerHigh: _appColors.surfaceContainerHigh,
        surfaceContainerLow: _appColors.surfaceContainerLow,
        inversePrimary: _appColors.primaryContainer,
        inverseSurface: _appColors.surface,
        onInverseSurface: _appColors.onSurface,
        scrim: _appColors.outlineVariant,
        shadow: _appColors.outline,
        tertiary: _appColors.secondary,
        onTertiary: _appColors.onSecondary,
      ),
      dividerTheme: DividerThemeData(
        color: _appColors.outline.withOpacity(0.2),
      ),
      extensions: [
        _customButtonColors,
        _gradientColors,
        _switcherColors,
        _textFieldColors,
        _commonUIColors,
      ],
      navigationBarTheme: _navigationBarTheme,
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
        brightness: _colorSchemeBrightness,
        primaryColor: _appColors.primary,
        scaffoldBackgroundColor: _scaffoldBackgroundColor,
        applyThemeToAll: true,
      ),

      cardColor: _appColors.surfaceContainer,
      checkboxTheme: _checkboxTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: _appColors.onSurface),
        titleTextStyle: TextStyle(
          color: _appColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
      scaffoldBackgroundColor: _scaffoldBackgroundColor,
      inputDecorationTheme: _inputDecorationTheme,
      popupMenuTheme: PopupMenuThemeData(
        surfaceTintColor: Colors.transparent,
        color: _appColors.surface,
        textStyle: TextStyle(
          color: _appColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((
          Set<WidgetState> states,
        ) {
          return TextStyle(
            color: _appColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: fontFamily,
          );
        }),
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: _appColors.onSurface,
        textColor: _appColors.onSurface,
        titleTextStyle: TextStyle(
          color: _appColors.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        subtitleTextStyle: TextStyle(
          color: _appColors.onSurface.withOpacity(0.7),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
      ),
      expansionTileTheme: expansionTileThemeData,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _appColors.switcherColors.neutralColors.shade200;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _appColors.switcherColors.neutralColors.shade400;
            }
            return _appColors.primary;
          }),
          textStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
            );
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _appColors.switcherColors.neutralColors.shade100;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _appColors.switcherColors.neutralColors.shade400;
            }
            return _appColors.primary;
          }),
          textStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
            );
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? _appColors.switcherColors.neutralColors.shade200
                  : _appColors.primary,
            );
          }),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _customButtonColors.disabledButtonBGColor;
            }
            return _customButtonColors.primaryButtonBGColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return _customButtonColors.disabledButtonFGColor;
            }
            return _customButtonColors.primaryButtonFGColor;
          }),
          textStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamily,
            );
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
      ),
    );
  }
}

extension on Brightness {
  TextTheme toTypography(String fontFamily) {
    return (this == Brightness.dark ? Typography().white : Typography().black)
        .apply(fontFamily: fontFamily);
  }
}

/// Extension on BuildContext for easy access to colors
extension AppThemeExtension on BuildContext {
  /// Get current app colors
  AppColors get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? AppColorsDark() : AppColorsLight();
  }

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
