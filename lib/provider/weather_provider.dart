import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/model/airInfo.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/model/weatherInfo.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';

class WeatherProvider with ChangeNotifier {
  bool _isLoading = false;
  String _error = '';

  GeoInfo? _geoInfo;
  WeatherInfo? _weatherInfo;
  AirInfo? _airInfo;

  List<GeoInfo> _savedCities = [];

  // 使用 getter 方法获取数据，避免直接暴露私有变量
  bool get isLoading => _isLoading;
  String get error => _error;
  GeoInfo? get geoInfo => _geoInfo;
  WeatherInfo? get weatherInfo => _weatherInfo;
  AirInfo? get airInfo => _airInfo;
  List<GeoInfo> get savedCities => _savedCities;

  get curWeatherInfo => null;

  get curGeoInfo => null;

  get curAirInfo => null;

  void addCityToSavedCities(GeoInfo city) {
    _savedCities.add(city);
    notifyListeners();
  }

  // 将 savedCities 保存到本地存储
  Future<void> saveSavedCitiesToLocal() async {
    // 使用 GetIt 获取 SharedPreferences 实例
    // final prefs = GetIt.I<SharedPreferences>();
    // 将 savedCities 转换为 JSON 字符串并保存到 SharedPreferences
  //   TODO: 保存 savedCities 到本地存储

  }

  // 将获取数据的逻辑提取到单独的函数中
  Future<void> _fetchData(Future Function() fetchFunction) async {
    try {
      _isLoading = true;
      notifyListeners();
      await fetchFunction();
      _error = ''; // 清空错误信息
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 使用 _fetchData 函数获取天气数据
  Future<void> loadWeatherDataByLocation(double lat, double lon) async {
    await _fetchData(() async {
      final geoapiService = GetIt.I<GeoapiService>();
      final weatherService = GetIt.I<WeatherService>();
      _geoInfo = await geoapiService.getCurrentGeoIDByLocation(lat, lon);
      _weatherInfo = await weatherService.getCityWeatherNowByPosition(lat, lon);
      _airInfo = await weatherService.getCityAirByPosition(lat, lon);
    });
  }

  // 使用 _fetchData 函数获取天气数据
  Future<void> loadWeatherDataByCityName(String cityName) async {
    await _fetchData(() async {
      final geoapiService = GetIt.I<GeoapiService>();
      final weatherService = GetIt.I<WeatherService>();
      _geoInfo = await geoapiService.getCurrentGeoIDByCityName(cityName);
      _weatherInfo = await weatherService.getCityWeatherNowByGeoID(_geoInfo!.location[0].id);
      _airInfo = await weatherService.getCityAirByGeoID(_geoInfo!.location[0].id);
    });
  }

  // 更新 geoInfo 并通知监听器
  void updateGeoInfo(GeoInfo city) {
    // _geoInfo = city;
    loadWeatherDataByCityName(city.location[0].name);

    notifyListeners();
  }



}