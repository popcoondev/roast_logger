
class LogEntry {
  final int time;
  final double temperature;
  final double? ror;
  final String? event;

  LogEntry({
    required this.time,
    required this.temperature,
    this.ror,
    this.event,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      time: json['time'],
      temperature: json['temperature'].toDouble(),
      ror: json['ror'] != null ? json['ror'].toDouble() : null,
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature': temperature,
      'ror': ror,
      'event': event,
    };
  }
}

class BeanInfo {
  final String name;
  final String origin;
  final String process;

  BeanInfo({
    required this.name,
    required this.origin,
    required this.process,
  });

  factory BeanInfo.fromJson(Map<String, dynamic> json) {
    return BeanInfo(
      name: json['name'],
      origin: json['origin'],
      process: json['process'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'origin': origin,
      'process': process,
    };
  }
}

class RoastInfo {
  final String date;
  final String time;
  final String roaster;
  final String preRoastWeight;
  final String postRoastWeight;
  final String roastTime;
  final double roastLevel;
  final String roastLevelName;

  RoastInfo({
    required this.date,
    required this.time,
    required this.roaster,
    required this.preRoastWeight,
    required this.postRoastWeight,
    required this.roastTime,
    required this.roastLevel,
    required this.roastLevelName,
  });

  factory RoastInfo.fromJson(Map<String, dynamic> json) {
    return RoastInfo(
      date: json['date'],
      time: json['time'],
      roaster: json['roaster'],
      preRoastWeight: json['preRoastWeight'],
      postRoastWeight: json['postRoastWeight'] ?? '',
      roastTime: json['roastTime'],
      roastLevel: json['roastLevel'].toDouble(),
      roastLevelName: json['roastLevelName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'roaster': roaster,
      'preRoastWeight': preRoastWeight,
      'postRoastWeight': postRoastWeight,
      'roastTime': roastTime,
      'roastLevel': roastLevel,
      'roastLevelName': roastLevelName,
    };
  }
}

class RoastLog {
  final List<LogEntry> logEntries;
  final int currentTime;
  final BeanInfo beanInfo;
  final RoastInfo roastInfo;

  RoastLog({
    required this.logEntries,
    required this.currentTime,
    required this.beanInfo,
    required this.roastInfo,
  });

  factory RoastLog.fromJson(Map<String, dynamic> json) {
    return RoastLog(
      logEntries: (json['logEntries'] as List)
          .map((e) => LogEntry.fromJson(e))
          .toList(),
      currentTime: json['currentTime'],
      beanInfo: BeanInfo.fromJson(json['beanInfo']),
      roastInfo: RoastInfo.fromJson(json['roastInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logEntries': logEntries.map((e) => e.toJson()).toList(),
      'currentTime': currentTime,
      'beanInfo': beanInfo.toJson(),
      'roastInfo': roastInfo.toJson(),
    };
  }
}
