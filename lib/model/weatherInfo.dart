class WeatherInfo {
  // late String cityName;
  final String temperature;
  final String description;
  final String observationTime;
  // final String iconCode;

  // final String weather_desc;

  WeatherInfo({
    // required this.cityName,
    required this.temperature,
    required this.observationTime,
    required this.description,
    // required this.iconCode,
    // required this.weather_desc,
  });

  // To string
  @override
  String toString() {
    return 'WeatherNow{temperature: $temperature, observationTime: $observationTime, description: $description}';
  }

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      // cityName: json['name'],
      temperature: json['now']['temp'],
      observationTime: json['now']['obsTime'],
      // weather_desc: json['now']['text'],
      description: json['now']['text'],
      // iconCode: json['now']['icon'],
    );
  }
}
