// models/roast_log.dart

import 'bean_info.dart';
import 'roast_info.dart';
import 'log_entry.dart';
import 'cupping_result.dart'; // 追加

class RoastLog {
  List<LogEntry> logEntries;
  int currentTime;
  BeanInfo beanInfo;
  RoastInfo roastInfo;
  List<CuppingResult> cuppingResults;

  RoastLog({
    required this.logEntries,
    required this.currentTime,
    required this.beanInfo,
    required this.roastInfo,
    this.cuppingResults = const [], // 初期値は null
  });
}
