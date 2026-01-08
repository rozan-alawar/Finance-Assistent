import 'package:flutter/material.dart';

extension ColoTextX on TextStyle {
  TextStyle colorWith(Color color) => copyWith(color: color);
  TextStyle fontWeightWith(FontWeight fontWeight) => copyWith(fontWeight: fontWeight);
}
