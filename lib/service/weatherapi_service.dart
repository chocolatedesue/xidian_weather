// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:xidian_weather/model/airInfo.dart';
import 'package:xidian_weather/model/geoPositon.dart';

import 'package:xidian_weather/model/weatherInfo.dart';

class WeatherService {
  final String weatherBaseUrl = 'https://devapi.qweather.com/v7';

  String authKey;

  WeatherService(this.authKey);

  Future<AirInfo> getCityAirByGeoID(String geoID) async {
    var url = '$weatherBaseUrl/air/now?location=$geoID&key=$authKey';
    // var response = await http.get(Uri.parse(url));
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load air data');
    }

    var responseJson = response.data;

    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load air data');
    } else {
      AirInfo airData = AirInfo.fromJson(response.data);
      return airData;
    }
  }



  Future<WeatherInfo> getCityWeatherNowByGeoID(String geoID) async {
    var url = '$weatherBaseUrl/weather/now?location=$geoID&key=$authKey';
    // var response = await http.get(Uri.parse(url));
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    var responseJson = response.data;

    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load weather data');
    } else {
      WeatherInfo weatherData = WeatherInfo.fromJson(response.data);
      return weatherData;
    }
  }

  Future<WeatherInfo> getCityWeatherNowByPosition(
      GeoPosiition geoPosition) async {
    var lat = double.parse(geoPosition.latitude).toStringAsFixed(2);
    var lon = double.parse(geoPosition.longitude).toStringAsFixed(2);

    var url = '$weatherBaseUrl/weather/now?location=$lat,$lon&key=$authKey';
    // var url =
    // '$weatherBaseUrl/weather/now?location=${},${geoPosition.longitude}&key=$authKey';
    // var url = '$weatherBaseUrl/weather/now?location=$cityName&key=$authKey';
    // var response = await http.get(Uri.parse(url));
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    var responseJson = response.data;

    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load weather data');
    } else {
      WeatherInfo weatherData = WeatherInfo.fromJson(response.data);
      // weatherData.cityName = cityName;
      return weatherData;
    }
    // return weatherData;
  }
}
