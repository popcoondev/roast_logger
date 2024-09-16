// models/cupping_result.dart

class CuppingResult {
  double aroma;
  double flavor;
  double aftertaste;
  double acidity;
  double body;
  double balance;
  double overall;
  String notes;

  CuppingResult({
    this.aroma = 0.0,
    this.flavor = 0.0,
    this.aftertaste = 0.0,
    this.acidity = 0.0,
    this.body = 0.0,
    this.balance = 0.0,
    this.overall = 0.0,
    this.notes = '',
  });

  // JSON への変換やデータの保存のために、toJson, fromJson メソッドを追加することができます
}
