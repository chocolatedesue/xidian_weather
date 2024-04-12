// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

class WeatherService {
  Future<dynamic> getCityWeather(String cityName) async {
    var url =
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=[Your_API_Key]';
    // var response = await http.get(Uri.parse(url));
    var response = await Dio().get(url);

    var weatherData = jsonDecode(response.toString());
    return weatherData;
  }
}
