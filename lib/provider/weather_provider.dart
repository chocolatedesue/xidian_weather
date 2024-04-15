import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xidian_weather/model/airInfo.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/model/weatherInfo.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = '';

  GeoInfo? geoInfo;
  WeatherInfo? weatherInfo;
  AirInfo? airInfo;


  loadWeatherDataByLocation(double lat, double lon) async {
    final geoapiService = GetIt.I<GeoapiService>();
    final weatherService = GetIt.I<WeatherService>();
    isLoading = true;
    notifyListeners();

    geoInfo = await geoapiService.getCurrentGeoIDByLocation(lat, lon);
    // geoInfo = await geoapiService.getCurrentGeoIDByLocation(lat, lon);
    weatherInfo = await weatherService.getCityWeatherNowByPosition(lat, lon);
    airInfo = await weatherService.getCityAirByPosition(lat, lon);

    isLoading = false;
    notifyListeners();
  }


  
  loadWeatherDataByCityName(String cityName) async {
      final geoapiService = GetIt.I<GeoapiService>();
      final weatherService = GetIt.I<WeatherService>();
      isLoading = true; 
      notifyListeners();
      
      geoInfo = await geoapiService.getCurrentGeoIDByCityName(cityName);
      weatherInfo = await weatherService.getCityWeatherNowByGeoID(geoInfo!.id);
      airInfo = await weatherService.getCityAirByGeoID(geoInfo!.id);
      
      isLoading = false;
      notifyListeners();    
   
  }
  


}
