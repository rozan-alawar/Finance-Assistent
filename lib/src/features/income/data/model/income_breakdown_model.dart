
import 'package:flutter/material.dart';

class IncomeBreakdown {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  const IncomeBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}