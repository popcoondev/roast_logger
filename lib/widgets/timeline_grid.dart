// widgets/timeline_grid.dart

import 'package:flutter/material.dart';
import '../models/log_entry.dart';
import '../utils/events.dart';

class TimelineGrid extends StatelessWidget {
  final List<LogEntry> logEntries;

  const TimelineGrid({Key? key, required this.logEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // カラム幅の調整
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double columnWidth = MediaQuery.of(context).size.width / 5;
    if (isLandscape) {
      columnWidth = MediaQuery.of(context).size.width / 5 / 3;
    }

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16.0,
            columns: [
              DataColumn(label: SizedBox(width: columnWidth, child: const Text('Time'))),
              DataColumn(label: SizedBox(width: columnWidth, child: const Text('Temp (°C)'))),
              DataColumn(label: SizedBox(width: columnWidth, child: const Text('ROR'))),
              DataColumn(label: SizedBox(width: columnWidth, child: const Text('Phase'))),
            ],
            rows: logEntries.map((entry) {
              String eventDisplay = entry.event == Event.none ? '-' : entry.event!;
              return DataRow(cells: [
                DataCell(Text('${entry.time ~/ 60}:${(entry.time % 60).toString().padLeft(2, '0')}')),
                DataCell(Text('${entry.temperature}')),
                DataCell(Text('${entry.ror ?? ''}')),
                DataCell(Text(eventDisplay)),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
