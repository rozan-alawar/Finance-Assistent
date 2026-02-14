import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/theme/styles/styles.dart';

class PercentageScatterChart extends StatelessWidget {
  const PercentageScatterChart({super.key});

  static const minRadius = 20.0;
  static const maxRadius = 140.0;

  // Cache static data to avoid recreation on every build
  static const List<int> _percentages = [48, 32, 25, 18];
  
  static const List<Offset> _positions = [
    Offset(2.4, 5),
    Offset(6, 7),
    Offset(5.5, 2),
    Offset(8.2, 4),
  ];

  static const List<Color> _colors = [
    Color.fromARGB(255, 242, 242, 255),
    Color.fromARGB(255, 255, 245, 250),
    Color.fromARGB(255, 255, 247, 247),
    Color.fromARGB(255, 242, 247, 255),
  ];

  static const List<Color> _percentageTextColor = [
    Color(0xFF686FFF),
    Color(0xFFFFA9DC),
    Color(0xFFFFBDBC),
    Color(0xFF5792FF),
  ];

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

            final spots = List.generate(4, (index) {
              return ScatterSpot(
                _positions[index].dx,
                _positions[index].dy,
                dotPainter: FlDotCirclePainter(
                  radius: _radiusFromPercentage(_percentages[index]),
                  color: _colors[index],
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

                ...List.generate(4, (index) {
                  final center = chartToPixel(
                    _positions[index].dx,
                    _positions[index].dy,
                  );

                  return Positioned(
                    left: center.dx - 12,
                    top: center.dy - 12,
                    child: Text(
                      '${_percentages[index]}%',
                      style: TextStyles.f16(
                        context,
                      ).medium.copyWith(color: _percentageTextColor[index]),
                      textAlign: TextAlign.center,
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
