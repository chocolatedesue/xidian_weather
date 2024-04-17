// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:xidian_weather/model/my7DayWeather.dart';
import 'package:xidian_weather/model/airInfo.dart';
import 'package:xidian_weather/model/geoPositon.dart';

import 'package:xidian_weather/model/cur_weatherInfo.dart';

class WeatherService {
  final String weatherBaseUrl = 'https://devapi.qweather.com/v7';

  String authKey;

  WeatherService(this.authKey);

  Future<The7DayWeather> get7DayWeatherByGeoID(String geoID) async {
    var url = '$weatherBaseUrl/weather/7d?location=$geoID&key=$authKey';
    // var response = await http.get(Uri.parse(url));
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    var responseJson = response.data;

    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load weather data');
    } else {
      The7DayWeather weatherData = The7DayWeather.fromJson(response.data);
      return weatherData;
    }
  }

  Future<The7DayWeather> get7DayWeatherByPosition(double lat, double lon) async {
    lat = double.parse(lat.toStringAsFixed(2));
    lon = double.parse(lon.toStringAsFixed(2));
    var url = '$weatherBaseUrl/weather/7d?location=$lon,$lat&key=$authKey';
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    var responseJson = response.data;

    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load weather data');
    } else {
      The7DayWeather weatherData = The7DayWeather.fromJson(responseJson);
      return weatherData;
    }
  }




  Future<AirInfo> getCityAirByPosition (double lat, double lon) async {
    lat = double.parse(lat.toStringAsFixed(2));
    lon = double.parse(lon.toStringAsFixed(2));
    var url = '$weatherBaseUrl/air/now?location=$lon,$lat&key=$authKey';
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load air data');
    }

    var responseJson = response.data;

    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load air data');
    } else {
      AirInfo airData = AirInfo.fromJson(responseJson);
      return airData;
    }
  }


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



  Future<CurWeatherInfo> getCityWeatherNowByGeoID(String geoID) async {

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
      CurWeatherInfo weatherData = CurWeatherInfo.fromJson(response.data);
      return weatherData;
    }
  }

  Future<CurWeatherInfo> getCityWeatherNowByPosition(
      double lat , double lon) async {
        lat = double.parse(lat.toStringAsFixed(2));
        lon = double.parse(lon.toStringAsFixed(2));
    // var lat = double.parse(geoPosition.latitude).toStringAsFixed(2);
    // var lon = double.parse(geoPosition.longitude).toStringAsFixed(2);

    var url = '$weatherBaseUrl/weather/now?location=$lon,$lat&key=$authKey';
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
      CurWeatherInfo weatherData = CurWeatherInfo.fromJson(response.data);
      // weatherData.cityName = cityName;
      return weatherData;
    }
    // return weatherData;
  }
}
