// models/roast_info.dart

class RoastInfo {
  String date;
  String time;
  String roaster;
  String preRoastWeight;
  String postRoastWeight;
  String roastTime;
  double roastLevel;
  String roastLevelName;

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
}
