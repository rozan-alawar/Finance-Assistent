import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'color_palette.dart';
import 'extensions_color.dart';

/// Dark theme color
class AppColorsDark implements AppColors {
  // Brand colors
  @override
  Color get seedColor => ColorPalette.blue30; // #30AAFA

  @override
  Color get primary => ColorPalette.blue50; // #5178BE

  @override
  Color get primaryContainer => ColorPalette.blue20; // #7CC7FF

  @override
  Color get onPrimary => ColorPalette.white;

  @override
  Color get secondary => ColorPalette.blue30; // #30AAFA

  @override
  Color get onSecondary => ColorPalette.black;

  @override
  Color get secondaryLight => ColorPalette.blue10; // #C0EFFF

  @override
  Color get tertiaryFixed => ColorPalette.black;

  // Surface colors
  @override
  Color get surface => ColorPalette.gray90; // Dark background

  @override
  Color get surfaceTint => ColorPalette.blue10;

  @override
  Color get surfaceContainer => ColorPalette.gray80;

  @override
  Color get surfaceBright => ColorPalette.blue30;

  @override
  Color get onSurface => ColorPalette.gray30;

  @override
  Color get onSurfaceDim => ColorPalette.white;

  // Surface variants
  @override
  Color get surfaceContainerHighest => ColorPalette.green40;

  @override
  Color get surfaceContainerHigh => ColorPalette.yellow20;

  @override
  Color get surfaceContainerLow => ColorPalette.red50;

  // Outline colors
  @override
  Color get outline => ColorPalette.gray70;

  @override
  Color get outlineVariant => ColorPalette.coldGray70;

  // Background
  @override
  Color get background => ColorPalette.gray90;

  // Status colors
  @override
  Color get error => ColorPalette.red40;

  // UI element colors
  @override
  Color get icon => ColorPalette.white;

  @override
  Color get font => ColorPalette.white;

  @override
  Color get expansionTileColor => const Color(0xFF0C1425);

  // Text field colors
  @override
  Color get hintColor => ColorPalette.gray50;

  @override
  Color get textFieldFieldColor => ColorPalette.coldGray30;

  @override
  Color get textFieldFocusBorderColor => ColorPalette.blue50;

  @override
  Color get textFieldPrefixIconColor => ColorPalette.gray40;

  @override
  Color get textFieldSuffixIconColor => ColorPalette.gray40;

  // Button colors
  @override
  ButtonColors get customButtonColors => ButtonColors(
    primaryButtonBGColor: primary,
    primaryButtonFGColor: background,
    secondaryButtonBGColor: _neutralColors.shade600,
    secondaryButtonFGColor: ColorPalette.white,
    dangerButtonBGColor: error,
    dangerButtonFGColor: ColorPalette.white,
    txtButtonColor: primary,
    disabledButtonBGColor: ColorPalette.gray70,
    disabledButtonFGColor: ColorPalette.gray60,
  );

  // Gradient colors
  @override
  GradientColors get gradientColors => GradientColors(
    scaffold: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 1.0],
      colors: [_neutralColors.shade600, const Color(0xFF0D192E)],
    ),
    cardLoginOrRegister: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _blueColors.shade800.withAlpha(34),
        _blueColors.shade800.withAlpha(88),
        _blueColors.shade800.withAlpha(92),
        _blueColors.shade800,
        _blueColors.shade800,
      ],
    ),
  );

  // Switcher colors
  @override
  SwitcherColors get switcherColors => SwitcherColors(
    primaryColor: primary,
    dangerColor: error,
    warningColor: ColorPalette.orange30,
    successColor: ColorPalette.green40,
    bottomSheetBackground: ColorPalette.gray80,
    toastBGColor: const Color(0xFF353535),
    neutralColors: _neutralColors,
    primaryColors: _primaryColors,
    blueSwitch: _blueColors, secondaryColor: seedColor,
  );

  @override
  TextFieldColors get textFieldColors => TextFieldColors(
    fillColor: textFieldFieldColor,
    borderColor: ColorPalette.coldGray30,
    focusedBorderColor: ColorPalette.primary,
    labelColor: _neutralColors.shade500,
    hintColor: _neutralColors.shade500,
    requiredMarkColor: ColorPalette.red60,
    borderRadius: 12.0,
  );

  @override
  CommonUIColors get commonUIColors => CommonUIColors(
    surface: ColorPalette.black,
    onSurface: Colors.white,
    divider: _neutralColors.shade60,
    border: textFieldFocusBorderColor,
    iconColor: _neutralColors.shade400,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    cardBackground: ColorPalette.black,
    lightBackground: ColorPalette.black,
    darkText: ColorPalette.white,
    white: Colors.white,
    black: Colors.black,
    blueText: ColorPalette.blue30,
    dangerLight: ColorPalette.red20,
    bottomSheetHandle: ColorPalette.black.withValues(alpha: .6),
    buttonSecondaryLight: ColorPalette.secondary,
    hamburgerButton: ColorPalette.secondary,
    lightBlueBackground: ColorPalette.blue30,
  );

  // Color swatches
  static const _neutralColors = NeutralColors(0xFF424750, {
    40: Color(0xFF202632),
    50: ColorPalette.white,
    60: Color(0xFFE8E9EA),
    70: Color(0xFFB7BABE),
    80: Color(0xFF95989E),
    90: Color(0xFF262D3B),
    100: Color(0xFF8E98A8),
    200: Color(0xFFB6B8BB),
    300: Color(0xFF92959A),
    400: Color(0xFF61656C),
    500: Color(0xFF424750),
    600: Color(0xFF131924),
    700: Color(0xFF111721),
    800: Color(0xFF0D121A),
    900: Color(0xFF0A0E14),
    1000: Color(0xFF080E19),
  });

  static const _primaryColors = PrimaryColors(0xFF5178BE, {
    50: ColorPalette.blue10,
    500: ColorPalette.blue50,
  });

  static const _blueColors = BlueColors(0xFF131924, {
    500: Color(0xFF131924),
    600: Color(0xFF0D192E),
    700: Color(0xFF050E1F),
    800: Color(0xFF0B1221),
    900: Color(0xFF080E19),
    1000: Color(0xFF161d2c),
  });
}
