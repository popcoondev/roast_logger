// models/roast_info.dart
import 'package:uuid/uuid.dart';

class RoastBean {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String date;
  String time;
  String roaster;
  String preRoastWeight;
  String postRoastWeight;
  String roastTime;
  String roastLevel;
  String roastLevelName;
  String greenBeanId;
  String description;
  String notes;

  RoastBean({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.date = '',
    this.time = '',
    this.roaster = '',
    this.preRoastWeight = '',
    this.postRoastWeight = '',
    this.roastTime = '',
    this.roastLevel = '',
    this.roastLevelName = '',
    this.greenBeanId = '',
    this.description = '',
    this.notes = '',
  }) : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'date': date,
      'time': time,
      'roaster': roaster,
      'preRoastWeight': preRoastWeight,
      'postRoastWeight': postRoastWeight,
      'roastTime': roastTime,
      'roastLevel': roastLevel,
      'roastLevelName': roastLevelName,
      'greenBeanId': greenBeanId,
      'description': description,
      'notes': notes,
    };
  }

  static RoastBean fromMap(Map<String, dynamic> map) {
    return RoastBean(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      date: map['date'],
      time: map['time'],
      roaster: map['roaster'],
      preRoastWeight: map['preRoastWeight'],
      postRoastWeight: map['postRoastWeight'],
      roastTime: map['roastTime'],
      roastLevel: map['roastLevel'],
      roastLevelName: map['roastLevelName'],
      greenBeanId: map['greenBeanId'],
      description: map['description'],
      notes: map['notes'],
    );
  }

}
