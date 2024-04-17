import 'package:dio/dio.dart'; // import 'package:geolocator/geolocator.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/model/geoPositon.dart';

class GeoapiService {
  final baseUrl = 'https://geoapi.qweather.com/v2';
  late String _authkey;

  GeoapiService(this._authkey);

  updateAuthKey (String key) {
    _authkey = key;
  }

  Future<GeoInfo> getCurrentGeoIDByLocation(double lat, double lon) async {
    lat = double.parse(lat.toStringAsFixed(2));
    lon = double.parse(lon.toStringAsFixed(2));

    var url = '$baseUrl/city/lookup?location=$lon,$lat&key=$_authkey';
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
      // var id = responseJson['location'][0]['id'];
      // var cityName = responseJson['location'][0]['name'];
      // return G(id: id, cityName: cityName);
      return GeoInfo.fromJson(responseJson);
    }
    // return await Geolocator.getCurrentPosition(
  }

  Future<GeoInfo> getCurrentGeoIDByCityName(String cityName) async {
    var url = '$baseUrl/city/lookup?location=$cityName&key=$_authkey';
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
      // var id = responseJson['location'][0]['id'];
      // var cityName = responseJson['location'][0]['name'];
      // return G(id: id, cityName: cityName);
      return GeoInfo.fromJson(responseJson);
    }
    // return await Geolocator.getCurrentPosition(
  }

  //  only work for cn city
  Future<GeoPosiition> getCurrentPositionByCityName(String cityName) async {
    var url = '$baseUrl/city/lookup?location=$cityName&key=$_authkey';
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
      return GeoPosiition(lat: lat, lon: lon);
    }
    // return await Geolocator.getCurrentPosition(
  }
}
