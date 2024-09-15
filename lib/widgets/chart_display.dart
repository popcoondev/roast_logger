// widgets/chart_display.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/log_entry.dart';

class ChartDisplay extends StatelessWidget {
  final List<LogEntry> logEntries;

  const ChartDisplay({Key? key, required this.logEntries}) : super(key: key);

  List<FlSpot> _getTemperatureSpots() {
    return logEntries.map((entry) {
      return FlSpot(entry.time.toDouble(), entry.temperature.toDouble());
    }).toList();
  }

  List<FlSpot> _getRorSpots() {
    return logEntries.map((entry) {
      return FlSpot(entry.time.toDouble(), entry.ror ?? 0);
    }).toList();
  }

  String _formatTime(double value) {
    int time = value.toInt();
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (logEntries.isEmpty) {
      return const Text('No data available');
    }

    List<FlSpot> temperatureSpots = _getTemperatureSpots();
    List<FlSpot> rorSpots = _getRorSpots();
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double height = isLandscape ? 400 : 200;
    return Column(
      children: [
        // 温度チャート
        SizedBox(
          height: height,
          width: double.infinity,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 120,
                    getTitlesWidget: (value, meta) {
                      return Text(_formatTime(value));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 40),
                ),
              ),
              minX: 0,
              maxX: temperatureSpots.last.x,
              minY: 0,
              maxY: 280,
              lineBarsData: [
                LineChartBarData(
                  spots: temperatureSpots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        // RORチャート
        SizedBox(
          height: 100,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 15),
                ),
              ),
              minX: 0,
              maxX: rorSpots.last.x,
              minY: -30,
              maxY: 30,
              lineBarsData: [
                LineChartBarData(
                  spots: rorSpots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
