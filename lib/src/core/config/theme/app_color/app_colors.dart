import 'package:flutter/material.dart';

import 'extensions_color.dart';

abstract class AppColors {
  // Brand colors
  Color get primary;
  Color get seedColor;
  Color get primaryContainer;
  Color get onPrimary;

  Color get secondary;
  Color get onSecondary;
  Color get secondaryLight;

  Color get tertiaryFixed;

  // Surface colors
  Color get surface;
  Color get surfaceTint;
  Color get surfaceContainer;
  Color get surfaceBright;
  Color get onSurface;
  Color get onSurfaceDim;

  GradientColors get gradientColors;

  ButtonColors get customButtonColors;

  SwitcherColors get switcherColors;

  TextFieldColors get textFieldColors;

  CommonUIColors get commonUIColors;
  // Surface variants
  Color get surfaceContainerHighest;
  Color get surfaceContainerHigh;
  Color get surfaceContainerLow;

  // Outline colors
  Color get outline;
  Color get outlineVariant;

  // Background
  Color get background;

  // Status colors
  Color get error;

  // UI element colors
  Color get icon;
  Color get font;
  Color get expansionTileColor;

  // Text field colors
  Color get hintColor;
  Color get textFieldFieldColor;
  Color get textFieldFocusBorderColor;
  Color get textFieldPrefixIconColor;
  Color get textFieldSuffixIconColor;
}

/// Neutral color swatch
class NeutralColors extends ColorSwatch<int> {
  const NeutralColors(super.primary, super.swatch);

  Color get shade40 => this[40]!;
  Color get shade50 => this[50]!;
  Color get shade60 => this[60]!;
  Color get shade70 => this[70]!;
  Color get shade80 => this[80]!;
  Color get shade90 => this[90]!;
  Color get shade100 => this[100]!;
  Color get shade200 => this[200]!;
  Color get shade300 => this[300]!;
  Color get shade400 => this[400]!;
  Color get shade500 => this[500]!;
  Color get shade600 => this[600]!;
  Color get shade700 => this[700]!;
  Color get shade800 => this[800]!;
  Color get shade900 => this[900]!;
  Color get shade1000 => this[1000]!;
}

/// Primary color swatch
class PrimaryColors extends ColorSwatch<int> {
  const PrimaryColors(super.primary, super.swatch);

  Color get shade50 => this[50]!;
  Color get shade500 => this[500]!;
}

/// Blue color swatch
class BlueColors extends ColorSwatch<int> {
  const BlueColors(super.primary, super.swatch);

  Color get shade500 => this[500]!;
  Color get shade600 => this[600]!;
  Color get shade700 => this[700]!;
  Color get shade800 => this[800]!;
  Color get shade900 => this[900]!;
  Color get shade1000 => this[1000]!;
}
