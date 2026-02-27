import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance_assistent/src/features/income/data/model/income_breakdown_model.dart';

class IncomeBreakdownSection extends StatelessWidget {
  final List<IncomeBreakdown> breakdownData;
  final String title;

  const IncomeBreakdownSection({
    super.key,
    required this.breakdownData,
    this.title = 'Income Breakdown',
  });

  String _formatNumber(double number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    const double chartSize = 180.0;
    const double startAngleOffset = -pi / 2.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1A1A),
          ),
        ),
        const SizedBox(height: 60),
        Center(
          child: SizedBox(
            height: 260,
            width: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: chartSize,
                  width: chartSize,
                  child: CustomPaint(
                    painter: DonutChartPainter(
                      breakdownData: breakdownData,
                      startAngleOffset: startAngleOffset,
                    ),
                  ),
                ),
                ..._buildDynamicPercentageCircles(chartSize, startAngleOffset),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
        ...breakdownData.map(
          (item) => _buildLegendItem(
            item.category,
            "\$${_formatNumber(item.amount)}",
            item.color,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDynamicPercentageCircles(
    double chartSize,
    double startOffset,
  ) {
    List<Widget> circles = [];
    double currentAngle = startOffset;
    double radius = chartSize / 2;

    for (var item in breakdownData) {
      double sweepAngle = (item.percentage / 100) * (2 * pi);
      double midAngle = currentAngle + (sweepAngle / 2);
      double x = cos(midAngle) * radius * 1.2;
      double y = sin(midAngle) * radius * 1.2;

      circles.add(
        Transform.translate(
          offset: Offset(x, y),
          child: _buildPercentageCircle("${item.percentage.toInt()}%"),
        ),
      );
      currentAngle += sweepAngle;
    }
    return circles;
  }

  Widget _buildPercentageCircle(String label) {
    return Container(
      width: 62,
      height: 62,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1D1D1D),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF707070), fontSize: 14),
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFF1D1D1D),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<IncomeBreakdown> breakdownData;
  final double startAngleOffset;

  DonutChartPainter({
    required this.breakdownData,
    required this.startAngleOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 48
      ..strokeCap = StrokeCap.butt;

    double startAngle = startAngleOffset;

    for (var item in breakdownData) {
      double sweepAngle = (item.percentage / 100) * (2 * pi);
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint..color = item.color,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
