// models/roast_log.dart

import 'green_bean.dart';
import 'roast_bean.dart';
import 'log_entry.dart';
import 'cupping_result.dart';
import 'package:uuid/uuid.dart';

class RoastLog {
  String? id = Uuid().v4();
  List<LogEntry> logEntries;
  int currentTime;
  GreenBean beanInfo;
  RoastBean roastInfo;
  List<CuppingResult>? cuppingResults;

  RoastLog({
    String? id,
    required this.logEntries,
    required this.currentTime,
    required this.beanInfo,
    required this.roastInfo,
    this.cuppingResults,
  }) : id = id ?? Uuid().v4();
}
