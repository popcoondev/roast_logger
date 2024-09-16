// models/chart_settings.dart

class ChartSettings {
  double tempYMax;
  double tempYMin;
  double rorYMax;
  double rorYMin;
  bool isCurved;
  double lineWidth;

  ChartSettings({
    this.tempYMax = 280,
    this.tempYMin = 0,
    this.rorYMax = 30,
    this.rorYMin = -30,
    this.isCurved = true,
    this.lineWidth = 2,
  });
}
