import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:xidian_weather/main.dart';
import 'package:xidian_weather/model/geoInfo.dart';
// import 'package:xidian_weather/model/geoPositon.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';
import 'dart:developer' as developer;

import 'package:xidian_weather/service/weatherapi_service.dart';
// import 'package:geolocator/geolocator.dart';

//  import 'package:my_app/example.dart';
void main() {
  test('weather api test', () async {
    setupData();

    var weatherService = GetIt.I.get<WeatherService>();
    var geoapiService = GetIt.I.get<GeoapiService>();


    GeoInfo geoInfo = await geoapiService.getCurrentGeoIDByCityName('西安');
    print ('geoID: $geoInfo');
  
    var weatherData = await weatherService.getCityWeatherNowByGeoID(geoInfo.id);
    // developer.log('weatherData: $weatherData');
    print ('weatherData: $weatherData');

    var airData = await weatherService.getCityAirByGeoID(geoInfo.id);
    // developer.log('airData: $airData');
    print ('airData: $airData');

  });

  test ("weather api 2", () async {
    setupData();
    var geoid = "101110101";
    var weatherService = GetIt.I.get<WeatherService>();
    var airData = await weatherService.getCityAirByGeoID(geoid);
    // print ('airData: $airData');
    print ('airData: ${airData.toJson()}');
  });


}
