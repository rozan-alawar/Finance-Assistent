import 'package:flutter/material.dart';

extension WidgetExtension on Widget? {
  Widget onTap(
    Function? function, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? focusColor,
    WidgetStateProperty<Color?>? overlayColor,
  }) {
    return InkWell(
      onTap: function as void Function()?,
      borderRadius: borderRadius,
      child: this,
      splashColor: splashColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      focusColor: focusColor,
      overlayColor: overlayColor,
    );
  }
}
