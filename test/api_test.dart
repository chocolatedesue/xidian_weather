import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:xidian_weather/main.dart';
import 'package:xidian_weather/model/geoInfo.dart';
// import 'package:xidian_weather/model/geoPositon.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';

// import 'package:geolocator/geolocator.dart';

//  import 'package:my_app/example.dart';
void main() {
  test('weather api test', () async {
    setupData();

    var weatherService = GetIt.I.get<WeatherService>();
    var geoapiService = GetIt.I.get<GeoapiService>();


    GeoInfo geoInfo = await geoapiService.getCurrentGeoIDByCityName('西安');
    // print ('geoID: $geoInfo');

    print (
      jsonEncode(geoInfo)
    );
  
    var weatherData = await weatherService.getCityWeatherNowByGeoID(geoInfo.location[0].id);
    // developer.log('weatherData: $weatherData');
    String weatherDataStr = jsonEncode(weatherData);
    print ('weatherData: $weatherDataStr');

    var airData = await weatherService.getCityAirByGeoID(geoInfo.location[0].id);
    // developer.log('airData: $airData');
    String airDataStr = jsonEncode(airData);
    print ('airData: $airDataStr');


  });

  test ("weather api 2", () async {
    setupData();
    var geoid = "101110101";
    var weatherService = GetIt.I.get<WeatherService>();
    var airData = await weatherService.getCityAirByGeoID(geoid);
    // print ('airData: $airData');
    print ('airData: ${airData.toJson()}');
  });

  test ("get_it test ", () async {
    setupData();
    sleep(const Duration(seconds: 1));
    var position = GetIt.I.get<Position>();

    print ('position: $position');

  });

  test ("api test 3", () async {
    double lat = 34.3416;
    double lon = 108.9398;
    await setupData();
    var weatherService = GetIt.I.get<WeatherService>();
    var weatherData = await weatherService.getCityWeatherNowByPosition(lat, lon);
    var airData = await weatherService.getCityAirByPosition(lat, lon);
    print ('weatherData: $weatherData');
    print ('airData: $airData');

  });

  test ("7days weather test", () async {
    await setupData();
    var weatherService = GetIt.I.get<WeatherService>();
    var geoapiService = GetIt.I.get<GeoapiService>();

    GeoInfo geoInfo = await geoapiService.getCurrentGeoIDByCityName('西安');
    var weatherData = await weatherService.get7DayWeatherByGeoID(geoInfo.location[0].id);
    var weatherStr = jsonEncode(weatherData.toJson());
    print ('7days weather: $weatherStr');
  });


}
