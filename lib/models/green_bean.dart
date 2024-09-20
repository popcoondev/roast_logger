// models/bean_info.dart
import 'package:uuid/uuid.dart';

class GreenBean {
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String name;
  String origin; // 生産国
  String process; // 加工法
  String variety; // 品種
  String farmName; // 生産者
  String altitude; // 標高
  String description; // 説明
  String notes; // ノート  

  GreenBean({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.name,
    this.origin = '',
    this.process = '',
    this.variety = '',
    this.farmName = '',
    this.altitude = '',
    this.description = '',
    this.notes = '',
  }) : id = id ?? Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(); 

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'name': name,
      'origin': origin,
      'process': process,
      'variety': variety,
      'farmName': farmName,
      'altitude': altitude,
      'description': description,
      'notes': notes,
    };
  }

  factory GreenBean.fromMap(Map<String, dynamic> map) {
    return GreenBean(
      id: map['id'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      name: map['name'],
      origin: map['origin'],
      process: map['process'],
      variety: map['variety'],
      farmName: map['farmName'],
      altitude: map['altitude'],
      description: map['description'],
      notes: map['notes'],
    );
  }
}
