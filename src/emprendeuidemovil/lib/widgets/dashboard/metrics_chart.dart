import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MetricsChart extends StatelessWidget {
  final int users;
  final int emprendimientos;
  final int publicaciones;

  const MetricsChart({
    super.key,
    required this.users,
    required this.emprendimientos,
    required this.publicaciones,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Usuarios');
                    case 1:
                      return const Text('Emprend.');
                    case 2:
                      return const Text('Public.');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
          barGroups: [
            _bar(0, users.toDouble(), Colors.blue),
            _bar(1, emprendimientos.toDouble(), Colors.green),
            _bar(2, publicaciones.toDouble(), Colors.orange),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
