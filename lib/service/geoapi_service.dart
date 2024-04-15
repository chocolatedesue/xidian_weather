
import 'package:dio/dio.dart';// import 'package:geolocator/geolocator.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/model/geoPositon.dart';

class GeoapiService {
  final baseUrl = 'https://geoapi.qweather.com/v2';
  late String authKey;

  GeoapiService(this.authKey);

  Future<GeoInfo> getCurrentGeoIDByCityName(String cityName) async {
    var url = '$baseUrl/city/lookup?location=$cityName&key=$authKey';
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    // var responseJson = jsonDecode(response.data);
    var responseJson = response.data;

    // if (responseJson['code'] != "200") {
    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load weather data');
    } else {
      var id = responseJson['location'][0]['id'];
      var cityName = responseJson['location'][0]['name'];
      // return G(id: id, cityName: cityName);
      return GeoInfo(id: id, cityName: cityName);
    }
    // return await Geolocator.getCurrentPosition(
  }

  //  only work for cn city
  Future<GeoPosiition> getCurrentPositionByCityName(String cityName) async {
    var url = '$baseUrl/city/lookup?location=$cityName&key=$authKey';
    var response = await Dio().get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    // var responseJson = jsonDecode(response.data);
    var responseJson = response.data;

    // if (responseJson['code'] != "200") {
    if (int.parse(responseJson['code']) != 200) {
      throw Exception('Failed to load weather data');
    } else {
      var lat = responseJson['location'][0]['lat'];
      var lon = responseJson['location'][0]['lon'];
      return GeoPosiition(latitude: lat, longitude: lon);
    }
    // return await Geolocator.getCurrentPosition(
  }
}
