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
  });

  // データ保存のために toJson と fromJson を追加できます
}
