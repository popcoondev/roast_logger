// models/bean_info.dart
import 'package:uuid/uuid.dart';

class BeanInfo {
  String id;
  String name;
  String origin;
  String process;

  BeanInfo({
    String? id,
    required this.name,
    required this.origin,
    required this.process,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'origin': origin,
      'process': process,
    };
  }

  factory BeanInfo.fromMap(Map<String, dynamic> map) {
    return BeanInfo(
      id: map['id'],
      name: map['name'],
      origin: map['origin'],
      process: map['process'],
    );
  }
}
