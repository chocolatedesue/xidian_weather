class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int humidity;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.humidity,
  });
}