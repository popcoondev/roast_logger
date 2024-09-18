// models/roast_info.dart
import 'package:uuid/uuid.dart';

class RoastInfo {
  String id;
  String date;
  String time;
  String roaster;
  String preRoastWeight;
  String postRoastWeight;
  String roastTime;
  double roastLevel;
  String roastLevelName;

  RoastInfo({
    String? id,
    required this.date,
    required this.time,
    required this.roaster,
    required this.preRoastWeight,
    required this.postRoastWeight,
    required this.roastTime,
    required this.roastLevel,
    required this.roastLevelName,
  }) : id = id ?? Uuid().v4();
}
