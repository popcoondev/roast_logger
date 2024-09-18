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
}
