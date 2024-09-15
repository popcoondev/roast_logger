// models/log_entry.dart

class LogEntry {
  int time;
  int temperature;
  double? ror;
  String? event;

  LogEntry({
    required this.time,
    required this.temperature,
    this.ror,
    this.event,
  });
}
