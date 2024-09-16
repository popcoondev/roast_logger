// widgets/chart_display.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:roast_logger/models/chart_settings.dart';
import '../models/log_entry.dart';

class ChartDisplay extends StatelessWidget {
  final List<LogEntry> logEntries;
  final ChartSettings chartSettings;

  const ChartDisplay({
    Key? key,
    required this.logEntries,
    required this.chartSettings,
  }) : super(key: key);

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
                topTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Temperature (°C)',
                    textAlign: TextAlign.left,
                  ),
                  sideTitles: SideTitles(showTitles: false),
                ),
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
                  sideTitles: SideTitles(showTitles: true, interval: 50, reservedSize: 46),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 50, reservedSize: 46),
                ),
              ),
              clipData: FlClipData.all(),
              minX: 0,
              maxX: temperatureSpots.last.x,
              minY: chartSettings.tempYMin,
              maxY: chartSettings.tempYMax,
              lineBarsData: [
                LineChartBarData(
                  spots: temperatureSpots,
                  isCurved: chartSettings.isCurved,
                  color: const Color(0xFF2196F3),
                  barWidth: chartSettings.lineWidth,
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
                topTitles: AxisTitles(
                  axisNameWidget: Text(
                    'ROR (°C/min)',
                    textAlign: TextAlign.left,
                  ),
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 50, reservedSize: 46),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 50, reservedSize: 46),
                ),
              ),
              clipData: FlClipData.all(),
              minX: 0,
              maxX: rorSpots.last.x,
              minY: chartSettings.rorYMin,
              maxY: chartSettings.rorYMax,
              lineBarsData: [
                LineChartBarData(
                  spots: rorSpots,
                  isCurved: chartSettings.isCurved,
                  color: const Color(0xFFE53935),
                  barWidth: chartSettings.lineWidth,
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
