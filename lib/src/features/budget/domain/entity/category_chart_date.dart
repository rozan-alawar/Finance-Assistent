import 'package:flutter/material.dart';

class CategoryChartData {
  final String title;
  final double amount;
  final int percentage;
  final Color color;
  final Color textColor;
  final Color bgColor;

  const CategoryChartData({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.textColor,
    required this.bgColor,
  });
}
