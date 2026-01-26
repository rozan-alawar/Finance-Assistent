import 'package:flutter/material.dart';

import 'app_colors.dart';

GradientColors appGradientColors(BuildContext context) =>
    Theme.of(context).extension<GradientColors>()!;

SwitcherColors appSwitcherColors(BuildContext context) =>
    Theme.of(context).extension<SwitcherColors>()!;

ButtonColors appButtonsColors(BuildContext context) =>
    Theme.of(context).extension<ButtonColors>()!;

TextFieldColors appTextFieldColors(BuildContext context) =>
    Theme.of(context).extension<TextFieldColors>()!;

CommonUIColors appCommonUIColors(BuildContext context) =>
    Theme.of(context).extension<CommonUIColors>()!;

class ButtonColors extends ThemeExtension<ButtonColors> {
  ButtonColors({
    required this.primaryButtonBGColor,
    required this.primaryButtonFGColor,
    required this.secondaryButtonBGColor,
    required this.secondaryButtonFGColor,
    required this.dangerButtonBGColor,
    required this.dangerButtonFGColor,
    required this.disabledButtonBGColor,
    required this.disabledButtonFGColor,
    required this.txtButtonColor,
  });

  final Color primaryButtonBGColor;
  final Color primaryButtonFGColor;

  final Color secondaryButtonBGColor;
  final Color secondaryButtonFGColor;

  final Color dangerButtonBGColor;
  final Color dangerButtonFGColor;

  final Color txtButtonColor;

  final Color disabledButtonBGColor;
  final Color disabledButtonFGColor;

  @override
  ThemeExtension<ButtonColors> copyWith() {
    return ButtonColors(
      primaryButtonBGColor: primaryButtonBGColor,
      primaryButtonFGColor: primaryButtonFGColor,
      secondaryButtonBGColor: secondaryButtonBGColor,
      secondaryButtonFGColor: secondaryButtonFGColor,
      dangerButtonBGColor: dangerButtonBGColor,
      dangerButtonFGColor: dangerButtonFGColor,
      disabledButtonBGColor: disabledButtonBGColor,
      disabledButtonFGColor: disabledButtonFGColor,
      txtButtonColor: txtButtonColor,
    );
  }

  @override
  ThemeExtension<ButtonColors> lerp(
    covariant ThemeExtension<ButtonColors>? other,
    double t,
  ) {
    if (other is! ButtonColors) {
      return copyWith();
    }
    return ButtonColors(
      primaryButtonBGColor: Color.lerp(
        primaryButtonBGColor,
        other.primaryButtonBGColor,
        t,
      )!,
      primaryButtonFGColor: Color.lerp(
        primaryButtonFGColor,
        other.primaryButtonFGColor,
        t,
      )!,
      secondaryButtonBGColor: Color.lerp(
        secondaryButtonBGColor,
        other.secondaryButtonBGColor,
        t,
      )!,
      secondaryButtonFGColor: Color.lerp(
        secondaryButtonFGColor,
        other.secondaryButtonFGColor,
        t,
      )!,
      dangerButtonBGColor: Color.lerp(
        dangerButtonBGColor,
        other.dangerButtonBGColor,
        t,
      )!,
      dangerButtonFGColor: Color.lerp(
        dangerButtonFGColor,
        other.dangerButtonFGColor,
        t,
      )!,
      disabledButtonBGColor: Color.lerp(
        disabledButtonBGColor,
        other.disabledButtonBGColor,
        t,
      )!,
      disabledButtonFGColor: Color.lerp(
        disabledButtonFGColor,
        other.disabledButtonFGColor,
        t,
      )!,
      txtButtonColor: Color.lerp(txtButtonColor, other.txtButtonColor, t)!,
    );
  }
}

class CommonUIColors extends ThemeExtension<CommonUIColors> {
  CommonUIColors({
    required this.surface,
    required this.onSurface,
    required this.divider,
    required this.border,
    required this.iconColor,
    required this.shadowColor,
    required this.cardBackground,
    required this.lightBackground,
    required this.darkText,
    required this.lightBlueBackground,
    required this.white,
    required this.black,
    required this.blueText,
    required this.dangerLight,
    required this.bottomSheetHandle,
    required this.buttonSecondaryLight,
    required this.hamburgerButton,
  });

  final Color surface;
  final Color onSurface;
  final Color divider;
  final Color border;
  final Color iconColor;
  final Color shadowColor;
  final Color cardBackground;
  final Color lightBackground;
  final Color darkText;
  final Color lightBlueBackground;
  final Color white;
  final Color black;
  final Color blueText;
  final Color dangerLight;
  final Color bottomSheetHandle;
  final Color buttonSecondaryLight;
  final Color hamburgerButton;

  @override
  ThemeExtension<CommonUIColors> copyWith({
    Color? surface,
    Color? onSurface,
    Color? divider,
    Color? border,
    Color? iconColor,
    Color? shadowColor,
    Color? cardBackground,
    Color? lightBackground,
    Color? darkText,
    Color? lightBlueBackground,
    Color? white,
    Color? black,
    Color? blueText,
    Color? dangerLight,
    Color? bottomSheetHandle,
    Color? buttonSecondaryLight,
    Color? hamburgerButton,
  }) {
    return CommonUIColors(
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      iconColor: iconColor ?? this.iconColor,
      shadowColor: shadowColor ?? this.shadowColor,
      cardBackground: cardBackground ?? this.cardBackground,
      lightBackground: lightBackground ?? this.lightBackground,
      darkText: darkText ?? this.darkText,
      lightBlueBackground: lightBlueBackground ?? this.lightBlueBackground,
      white: white ?? this.white,
      black: black ?? this.black,
      blueText: blueText ?? this.blueText,
      dangerLight: dangerLight ?? this.dangerLight,
      bottomSheetHandle: bottomSheetHandle ?? this.bottomSheetHandle,
      buttonSecondaryLight: buttonSecondaryLight ?? this.buttonSecondaryLight,
      hamburgerButton: hamburgerButton ?? this.hamburgerButton,
    );
  }

  @override
  ThemeExtension<CommonUIColors> lerp(
    covariant ThemeExtension<CommonUIColors>? other,
    double t,
  ) {
    if (other is! CommonUIColors) {
      return copyWith();
    }
    return CommonUIColors(
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      lightBackground: Color.lerp(lightBackground, other.lightBackground, t)!,
      darkText: Color.lerp(darkText, other.darkText, t)!,
      lightBlueBackground: Color.lerp(
        lightBlueBackground,
        other.lightBlueBackground,
        t,
      )!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      blueText: Color.lerp(blueText, other.blueText, t)!,
      dangerLight: Color.lerp(dangerLight, other.dangerLight, t)!,
      bottomSheetHandle: Color.lerp(
        bottomSheetHandle,
        other.bottomSheetHandle,
        t,
      )!,
      buttonSecondaryLight: Color.lerp(
        buttonSecondaryLight,
        other.buttonSecondaryLight,
        t,
      )!,
      hamburgerButton: Color.lerp(hamburgerButton, other.hamburgerButton, t)!,
    );
  }
}

class TextFieldColors extends ThemeExtension<TextFieldColors> {
  TextFieldColors({
    required this.fillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.labelColor,
    required this.hintColor,
    required this.requiredMarkColor,
    required this.borderRadius,
  });

  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color labelColor;
  final Color hintColor;
  final Color requiredMarkColor;
  final double borderRadius;

  @override
  ThemeExtension<TextFieldColors> copyWith({
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? labelColor,
    Color? hintColor,
    Color? requiredMarkColor,
    double? borderRadius,
  }) {
    return TextFieldColors(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      labelColor: labelColor ?? this.labelColor,
      hintColor: hintColor ?? this.hintColor,
      requiredMarkColor: requiredMarkColor ?? this.requiredMarkColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ThemeExtension<TextFieldColors> lerp(
    covariant ThemeExtension<TextFieldColors>? other,
    double t,
  ) {
    if (other is! TextFieldColors) {
      return copyWith();
    }
    return TextFieldColors(
      fillColor: Color.lerp(fillColor, other.fillColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      focusedBorderColor: Color.lerp(
        focusedBorderColor,
        other.focusedBorderColor,
        t,
      )!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      requiredMarkColor: Color.lerp(
        requiredMarkColor,
        other.requiredMarkColor,
        t,
      )!,
      borderRadius: t < 0.5 ? borderRadius : other.borderRadius,
    );
  }
}

class GradientColors extends ThemeExtension<GradientColors> {
  GradientColors({required this.scaffold, required this.cardLoginOrRegister});
  final LinearGradient scaffold;
  final LinearGradient cardLoginOrRegister;

  @override
  ThemeExtension<GradientColors> copyWith() {
    return GradientColors(
      scaffold: scaffold,
      cardLoginOrRegister: cardLoginOrRegister,
    );
  }

  @override
  ThemeExtension<GradientColors> lerp(
    covariant ThemeExtension<GradientColors>? other,
    double t,
  ) {
    if (other is! GradientColors) {
      return copyWith();
    }
    return GradientColors(
      scaffold: LinearGradient.lerp(scaffold, other.scaffold, t)!,
      cardLoginOrRegister: LinearGradient.lerp(
        cardLoginOrRegister,
        other.cardLoginOrRegister,
        t,
      )!,
    );
  }
}

class SwitcherColors extends ThemeExtension<SwitcherColors> {
  const SwitcherColors({
    required this.primaryColor,
    required this.dangerColor,
    required this.neutralColors,
    required this.warningColor,
    required this.toastBGColor,
    required this.successColor,
    required this.primaryColors,
    required this.blueSwitch,
    required this.bottomSheetBackground, required this.secondaryColor,
  });

  final Color primaryColor;
  final Color dangerColor;
  final Color warningColor;
  final Color successColor;
  final Color toastBGColor;
  final Color bottomSheetBackground;
  final NeutralColors neutralColors;
  final PrimaryColors primaryColors;
  final BlueColors blueSwitch;
  final Color secondaryColor;

  @override
  ThemeExtension<SwitcherColors> copyWith() {
    return SwitcherColors(
      primaryColor: primaryColor,
      dangerColor: dangerColor,
      neutralColors: neutralColors,
      warningColor: warningColor,
      toastBGColor: toastBGColor,
      successColor: successColor,
      primaryColors: primaryColors,
      blueSwitch: blueSwitch,
      bottomSheetBackground: bottomSheetBackground, secondaryColor: secondaryColor,
    );
  }

  @override
  ThemeExtension<SwitcherColors> lerp(
    covariant ThemeExtension<SwitcherColors>? other,
    double t,
  ) {
    if (other is! SwitcherColors) {
      return copyWith();
    }
    return SwitcherColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      toastBGColor: Color.lerp(toastBGColor, other.toastBGColor, t)!,
      neutralColors: NeutralColors(
        Color.lerp(
          neutralColors.shade500,
          other.neutralColors.shade500,
          t,
        )!.toARGB32(),
        <int, Color>{
          40: Color.lerp(
            neutralColors.shade40,
            other.neutralColors.shade40,
            t,
          )!,
          50: Color.lerp(
            neutralColors.shade50,
            other.neutralColors.shade50,
            t,
          )!,
          60: Color.lerp(
            neutralColors.shade60,
            other.neutralColors.shade60,
            t,
          )!,
          70: Color.lerp(
            neutralColors.shade70,
            other.neutralColors.shade70,
            t,
          )!,
          80: Color.lerp(
            neutralColors.shade80,
            other.neutralColors.shade80,
            t,
          )!,
          90: Color.lerp(
            neutralColors.shade90,
            other.neutralColors.shade90,
            t,
          )!,
          100: Color.lerp(
            neutralColors.shade100,
            other.neutralColors.shade100,
            t,
          )!,
          200: Color.lerp(
            neutralColors.shade200,
            other.neutralColors.shade200,
            t,
          )!,
          300: Color.lerp(
            neutralColors.shade300,
            other.neutralColors.shade300,
            t,
          )!,
          400: Color.lerp(
            neutralColors.shade400,
            other.neutralColors.shade400,
            t,
          )!,
          500: Color.lerp(
            neutralColors.shade500,
            other.neutralColors.shade500,
            t,
          )!,
          600: Color.lerp(
            neutralColors.shade600,
            other.neutralColors.shade600,
            t,
          )!,
          700: Color.lerp(
            neutralColors.shade700,
            other.neutralColors.shade700,
            t,
          )!,
          800: Color.lerp(
            neutralColors.shade800,
            other.neutralColors.shade800,
            t,
          )!,
          900: Color.lerp(
            neutralColors.shade900,
            other.neutralColors.shade900,
            t,
          )!,
        },
      ),
      primaryColors: PrimaryColors(
        Color.lerp(
          primaryColors.shade500,
          other.primaryColors.shade500,
          t,
        )!.toARGB32(),
        <int, Color>{
          50: Color.lerp(
            primaryColors.shade50,
            other.primaryColors.shade50,
            t,
          )!,
          500: Color.lerp(
            primaryColors.shade500,
            other.primaryColors.shade500,
            t,
          )!,
        },
      ),
      blueSwitch: BlueColors(
        Color.lerp(
          blueSwitch.shade500,
          other.blueSwitch.shade500,
          t,
        )!.toARGB32(),
        <int, Color>{
          500: Color.lerp(blueSwitch.shade500, other.blueSwitch.shade500, t)!,
          600: Color.lerp(blueSwitch.shade600, other.blueSwitch.shade600, t)!,
          700: Color.lerp(blueSwitch.shade700, other.blueSwitch.shade700, t)!,
          800: Color.lerp(blueSwitch.shade800, other.blueSwitch.shade800, t)!,
          900: Color.lerp(blueSwitch.shade900, other.blueSwitch.shade900, t)!,
          1000: Color.lerp(
            blueSwitch.shade1000,
            other.blueSwitch.shade1000,
            t,
          )!,
        },
      ),
      bottomSheetBackground: Color.lerp(
        bottomSheetBackground,
        other.bottomSheetBackground,
        t,
      )!, secondaryColor:      Color.lerp(secondaryColor, other.secondaryColor, t)!,

    );
  }
}
