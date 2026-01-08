import 'package:flutter/material.dart';

extension EmptySpace on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());

  EdgeInsetsGeometry get padding => EdgeInsets.all(toDouble());
  EdgeInsetsGeometry get paddingH => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsetsGeometry get paddingW =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsetsGeometry get paddingTop => EdgeInsets.only(top: toDouble());
  EdgeInsetsGeometry get paddingBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsetsGeometry get paddingStart =>
      EdgeInsetsDirectional.only(start: toDouble());
  EdgeInsetsGeometry get paddingEnd =>
      EdgeInsetsDirectional.only(end: toDouble());
}

extension IntExtensions on int? {
  /// Validate given int is not null and returns given value if null.
  int validate({int value = 0}) {
    return this ?? value;
  }
}

extension DoubleExtensions on double? {
  /// Validate given double is not null and returns given value if null.
  double validate({double value = 0.0}) => this ?? value;
}
