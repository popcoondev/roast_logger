// models/cupping_result.dart
import 'package:uuid/uuid.dart';

class CuppingResult {
  String? id;
  DateTime date;
  double flavor;
  double sweetness;
  double acidity;
  double mousefeel;
  double cleancup;
  double aftertaste;
  double balance;
  double overall;
  double score;
  String notes;
  List<String> flavors;

  CuppingResult({
    String? id,
    required this.date,
    this.flavor = 0,
    this.sweetness = 0,
    this.acidity = 0,
    this.mousefeel = 0,
    this.cleancup = 0,
    this.aftertaste = 0,
    this.balance = 0,
    this.overall = 0,
    this.score = 0,
    this.notes = '',
    this.flavors = const [],
  }) : id = id ?? Uuid().v4();

  // データ保存のために toJson と fromJson を追加できます
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'flavor': flavor,
        'sweetness': sweetness,
        'acidity': acidity,
        'mousefeel': mousefeel,
        'cleancup': cleancup,
        'aftertaste': aftertaste,
        'balance': balance,
        'overall': overall,
        'score': score,
        'notes': notes,
        'flavors': flavors,
      };

  factory CuppingResult.fromJson(Map<String, dynamic> json) => CuppingResult(
        date: DateTime.parse(json['date']),
        flavor: json['flavor'],
        sweetness: json['sweetness'],
        acidity: json['acidity'],
        mousefeel: json['mousefeel'],
        cleancup: json['cleancup'],
        aftertaste: json['aftertaste'],
        balance: json['balance'],
        overall: json['overall'],
        score: json['score'],
        notes: json['notes'],
        flavors: List<String>.from(json['flavors'] ?? []),
      );
}
