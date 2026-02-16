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
    return Center(
      child: SizedBox(
        height: 220,
        width: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer shadow ring
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Donut chart
            CustomPaint(
              size: const Size(200, 200),
              painter: _DonutChartPainter(
                expensesByCategory: expensesByCategory,
                totalExpenses: totalExpenses,
              ),
            ),
            // White inner circle for clean center
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            // Center text
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
    const strokeWidth = 34.0;
    const gapAngle = 0.08; // Visible gap between segments

    if (totalExpenses == 0) {
      final paint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
      return;
    }

    // Filter categories with expenses > 0
    final activeCategories = expensesByCategory.entries
        .where((entry) => entry.value > 0)
        .toList();

    // Sort by amount descending for better visual
    activeCategories.sort((a, b) => b.value.compareTo(a.value));

    final totalGap = gapAngle * activeCategories.length;
    final availableAngle = 2 * math.pi - totalGap;
    double startAngle = -math.pi / 2; // Start from top

    for (var i = 0; i < activeCategories.length; i++) {
      final entry = activeCategories[i];
      final percentage = entry.value / totalExpenses;
      final sweepAngle = availableAngle * percentage;

      final paint = Paint()
        ..color = entry.key.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle > 0.01 ? sweepAngle : 0.01,
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
