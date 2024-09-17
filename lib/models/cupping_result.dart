// models/cupping_result.dart

class CuppingResult {
  DateTime date;
  double aroma;
  double flavor;
  double sweetness;
  double acidity;
  double body;
  double cleanliness;
  double aftertaste;
  double balance;
  double overall;
  String notes;
  List<String> flavors;

  CuppingResult({
    required this.date,
    this.aroma = 0,
    this.flavor = 0,
    this.sweetness = 0,
    this.acidity = 0,
    this.body = 0,
    this.cleanliness = 0,
    this.aftertaste = 0,
    this.balance = 0,
    this.overall = 0,
    this.notes = '',
    this.flavors = const [],
  });

  // データ保存のために toJson と fromJson を追加できます
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'aroma': aroma,
        'flavor': flavor,
        'sweetness': sweetness,
        'acidity': acidity,
        'body': body,
        'cleanliness': cleanliness,
        'aftertaste': aftertaste,
        'balance': balance,
        'overall': overall,
        'notes': notes,
        'flavors': flavors,
      };

  factory CuppingResult.fromJson(Map<String, dynamic> json) => CuppingResult(
        date: DateTime.parse(json['date']),
        aroma: json['aroma'],
        flavor: json['flavor'],
        sweetness: json['sweetness'],
        acidity: json['acidity'],
        body: json['body'],
        cleanliness: json['cleanliness'],
        aftertaste: json['aftertaste'],
        balance: json['balance'],
        overall: json['overall'],
        notes: json['notes'],
        flavors: List<String>.from(json['flavors'] ?? []),
      );
}
