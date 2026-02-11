import 'package:flutter/material.dart';

enum ExpenseCategory {
  food(
    id: 'food',
    name: 'Food',
    icon: Icons.fastfood_rounded,
    color: Color(0xFFFFB74D), // Orange
  ),
  health(
    id: 'health',
    name: 'Health',
    icon: Icons.medical_services_rounded,
    color: Color(0xFFEF9A9A), // Light Red/Pink
  ),
  entertainment(
    id: 'entertainment',
    name: 'Entertainment',
    icon: Icons.movie_rounded,
    color: Color(0xFF90CAF9), // Light Blue
  ),
  transport(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car_rounded,
    color: Color(0xFFEF5350), // Red
  ),
  housing(
    id: 'housing',
    name: 'Housing',
    icon: Icons.home_rounded,
    color: Color(0xFF5C6BC0), // Indigo
  ),
  others(
    id: 'others',
    name: 'Others',
    icon: Icons.add_circle_outline_rounded,
    color: Color(0xFF78909C), // Blue Grey
  );

  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  /// Get category from id string (useful for parsing from JSON/storage)
  static ExpenseCategory fromId(String id) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.id == id,
      orElse: () => ExpenseCategory.others,
    );
  }
}
