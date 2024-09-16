// models/cupping_result.dart

class CuppingResult {
  DateTime date; // 日付を追加
  double aroma;
  double flavor;
  double aftertaste;
  double acidity;
  double body;
  double balance;
  double overall;
  String notes;
  List<String> flavors;

  CuppingResult({
    required this.date,
    this.aroma = 0.0,
    this.flavor = 0.0,
    this.aftertaste = 0.0,
    this.acidity = 0.0,
    this.body = 0.0,
    this.balance = 0.0,
    this.overall = 0.0,
    this.notes = '',
    this.flavors = const [],

  });

  // データ保存のために toJson と fromJson を追加できます
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'aroma': aroma,
        'flavor': flavor,
        'aftertaste': aftertaste,
        'acidity': acidity,
        'body': body,
        'balance': balance,
        'overall': overall,
        'notes': notes,
        'flavors': flavors,
      };

  factory CuppingResult.fromJson(Map<String, dynamic> json) => CuppingResult(
        date: DateTime.parse(json['date']),
        aroma: json['aroma'],
        flavor: json['flavor'],
        aftertaste: json['aftertaste'],
        acidity: json['acidity'],
        body: json['body'],
        balance: json['balance'],
        overall: json['overall'],
        notes: json['notes'],
        flavors: List<String>.from(json['flavors'] ?? []),
      );
}
