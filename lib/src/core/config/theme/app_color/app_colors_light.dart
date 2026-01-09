import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'color_palette.dart';
import 'extensions_color.dart';

/// Light theme
class AppColorsLight implements AppColors {
  // Brand colors
  @override
  Color get seedColor => ColorPalette.blue30; // #30AAFA

  @override
  Color get primary => ColorPalette.primary;

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
  Color get tertiaryFixed => ColorPalette.gray50; // #777677

  // Surface colors
  @override
  Color get surface => ColorPalette.gray10; // #E8E5E0

  @override
  Color get surfaceTint => ColorPalette.blue10; // #C0EFFF

  @override
  Color get surfaceContainer => ColorPalette.coldGray10; // #E0E5E9

  @override
  Color get surfaceBright => ColorPalette.blue30; // #30AAFA

  @override
  Color get onSurface => ColorPalette.gray60; // #6A5A5A

  @override
  Color get onSurfaceDim => ColorPalette.white;

  // Surface variants
  @override
  Color get surfaceContainerHighest => ColorPalette.green40; // Success

  @override
  Color get surfaceContainerHigh => ColorPalette.yellow20; // Warning

  @override
  Color get surfaceContainerLow => ColorPalette.red50; // Error

  // Outline colors
  @override
  Color get outline => ColorPalette.gray20; // #C8D2D7

  @override
  Color get outlineVariant => ColorPalette.coldGray20; // #C5C2D2

  // Background
  @override
  Color get background => ColorPalette.white; // #E8E5E0

  // Status colors
  @override
  Color get error => ColorPalette.red40; // #FF555C

  // UI element colors
  @override
  Color get icon => ColorPalette.white;

  @override
  Color get font => ColorPalette.white;

  @override
  Color get expansionTileColor => ColorPalette.gray10;

  // Text field colors
  @override
  Color get hintColor => ColorPalette.gray60;

  @override
  Color get textFieldFieldColor => ColorPalette.black.withValues(alpha: 0.02);

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
    secondaryButtonBGColor: surfaceContainer,
    secondaryButtonFGColor: primary,

    dangerButtonBGColor: error,
    dangerButtonFGColor: ColorPalette.white,
    txtButtonColor: primary,
    disabledButtonBGColor: ColorPalette.gray10,
    disabledButtonFGColor: ColorPalette.gray50,
  );

  // Gradient colors
  @override
  GradientColors get gradientColors => GradientColors(
    scaffold: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [background, ColorPalette.blue60],
    ),
    cardLoginOrRegister: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        ColorPalette.blue70.withAlpha(34),
        ColorPalette.blue70.withAlpha(88),
        ColorPalette.blue70.withAlpha(92),
        ColorPalette.blue70,
        ColorPalette.blue70,
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
    bottomSheetBackground: ColorPalette.white,
    toastBGColor: ColorPalette.gray80,
    neutralColors: _neutralColors,
    primaryColors: _primaryColors,
    blueSwitch: _blueColors,
  );
  @override
  TextFieldColors get textFieldColors => TextFieldColors(
    fillColor: textFieldFieldColor,
    borderColor: ColorPalette.coldGray10,
    focusedBorderColor: ColorPalette.primary,
    labelColor: _neutralColors.shade500,
    hintColor: _neutralColors.shade500,
    requiredMarkColor: ColorPalette.red60,
    borderRadius: 14,
  );

  @override
  CommonUIColors get commonUIColors => CommonUIColors(
    surface: ColorPalette.white,
    onSurface: Colors.black,
    divider: _neutralColors.shade60,
    border: textFieldFocusBorderColor,
    iconColor: _neutralColors.shade400,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    cardBackground: ColorPalette.white,
    lightBackground: ColorPalette.white,
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
    50: ColorPalette.primary,
    500: ColorPalette.purple10,
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
