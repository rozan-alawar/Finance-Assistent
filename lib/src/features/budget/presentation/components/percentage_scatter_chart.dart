import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/styles/styles.dart';
import '../../domain/entity/category_chart_date.dart';

class PercentageScatterChart extends StatelessWidget {
  final List<CategoryChartData> data;

  const PercentageScatterChart({super.key, required this.data});

  static const minRadius = 15.0;
  static const maxRadius = 75.0;

  List<Offset> get generatedPositions => List.generate(data.length, (index) {
    final angle = (index / data.length) * 2 * pi;
    final x = 5 + 3 * cos(angle);
    final y = 5 + 3 * sin(angle);
    return Offset(x, y);
  });

  double _radiusFromPercentage(int percent) {
    return minRadius + (percent / 100) * (maxRadius - minRadius);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            Offset chartToPixel(double x, double y) {
              return Offset((x / 10) * width, height - (y / 10) * height);
            }

            final spots = List.generate(data.length, (index) {
              final pos = generatedPositions[index];

              return ScatterSpot(
                pos.dx,
                pos.dy,
                dotPainter: FlDotCirclePainter(
                  radius: _radiusFromPercentage(data[index].percentage),
                  color: data[index].bgColor,
                ),
              );
            });

            return Stack(
              children: [
                ScatterChart(
                  ScatterChartData(
                    scatterSpots: spots,
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 10,
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),

                ...List.generate(data.length, (index) {
                  final pos = generatedPositions[index];
                  final center = chartToPixel(pos.dx, pos.dy);

                  return Positioned(
                    left: center.dx,
                    top: center.dy,
                    child: Transform.translate(
                      offset: const Offset(-20, -10),
                      child: Text(
                        '${data[index].percentage}%',
                        style: TextStyles.f16(
                          context,
                        ).medium.copyWith(color: data[index].textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
