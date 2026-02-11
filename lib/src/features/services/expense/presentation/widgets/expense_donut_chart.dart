import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/config/theme/styles/styles.dart';
import '../../domain/entities/expense_category.dart';

class ExpenseDonutChart extends StatelessWidget {
  final Map<ExpenseCategory, double> expensesByCategory;
  final double totalExpenses;

  const ExpenseDonutChart({
    super.key,
    required this.expensesByCategory,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(180, 180),
            painter: _DonutChartPainter(
              expensesByCategory: expensesByCategory,
              totalExpenses: totalExpenses,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$${totalExpenses.toStringAsFixed(0)}',
                style: TextStyles.f20(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final Map<ExpenseCategory, double> expensesByCategory;
  final double totalExpenses;

  _DonutChartPainter({
    required this.expensesByCategory,
    required this.totalExpenses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 24.0;
    const gapAngle = 0.04; // Small gap between segments

    if (totalExpenses == 0) {
      // Draw empty state
      final paint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
      return;
    }

    double startAngle = -math.pi / 2; // Start from top

    // Filter categories with expenses > 0
    final activeCategories = expensesByCategory.entries
        .where((entry) => entry.value > 0)
        .toList();

    for (var i = 0; i < activeCategories.length; i++) {
      final entry = activeCategories[i];
      final percentage = entry.value / totalExpenses;
      final sweepAngle = (2 * math.pi * percentage) - gapAngle;

      final paint = Paint()
        ..color = entry.key.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle > 0 ? sweepAngle : 0.01,
        false,
        paint,
      );

      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.totalExpenses != totalExpenses ||
        oldDelegate.expensesByCategory != expensesByCategory;
  }
}
