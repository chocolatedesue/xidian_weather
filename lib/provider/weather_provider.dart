import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/model/airInfo.dart';
// import 'package:xidian_weather/model/dailyForecast.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/model/cur_weatherInfo.dart';
import 'package:xidian_weather/model/my7DayWeather.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';
import 'package:xidian_weather/util/const.dart';

class WeatherProvider with ChangeNotifier {
  bool _isLoading = false;
  String _error = '';

  //  check system theme mode

  GeoInfo? _geoInfo;
  CurWeatherInfo? _weatherInfo;
  AirInfo? _airInfo;
  The7DayWeather? _the7dayWeather;
  List<GeoInfo> _savedCities = [];
  bool _isDarkMode = ThemeMode.system == ThemeMode.dark;
  bool _autoGetLocation = false;

  int _selectedCityCardIndex = -1;

  // 使用 getter 方法获取数据，避免直接暴露私有变量
  bool get isLoading => _isLoading;
  String get error => _error;
  GeoInfo? get geoInfo => _geoInfo;
  CurWeatherInfo? get weatherInfo => _weatherInfo;
  AirInfo? get airInfo => _airInfo;
  The7DayWeather? get the7dayWeather => _the7dayWeather;
  List<GeoInfo>? get savedCities => _savedCities;
  bool get isDarkMode => _isDarkMode;
  int get selectedCityCardIndex => _selectedCityCardIndex;
  bool get autoGetLocation => _autoGetLocation;
  // get isDarkMode => null;

  void addCityToSavedCities(GeoInfo city) async {
    _savedCities.add(city);
    await saveSavedCitiesToLocal();
    notifyListeners();
  }

  Future saveAutoGetLocationToLoacl(bool autoGetLocation) async {
    var prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setBool(AUTOGETLOCATION, autoGetLocation);
  }

  Future<void> updateAutoGetLocation(bool autoGetLocation) async {
    _autoGetLocation = autoGetLocation;
    await saveAutoGetLocationToLoacl(autoGetLocation);
    notifyListeners();
  }

  Future<void> saveAllWeatherInfoToLoacl() async {
    var prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setString(CURWEATHERINFO, jsonEncode(_weatherInfo!.toJson()));
    await prefs.setString(AIRINFO, jsonEncode(_airInfo!.toJson()));
    await prefs.setString(
        THE7DAYWEATHER, jsonEncode(_the7dayWeather!.toJson()));
  }

  Future<void> saveSavedCitiesToLocal() async {
    // var prefs = await SharedPreferences.getInstance();
    var prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setStringList(
      SAVEDCITIES,
      _savedCities.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> saveGeoInfoToLocal() async {
    // var prefs = await SharedPreferences.getInstance();
    var prefs = GetIt.I.get<SharedPreferences>();
    await prefs.setString(GEOINFO, jsonEncode(_geoInfo!.toJson()));
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
      _the7dayWeather =
          (await weatherService.get7DayWeatherByPosition(lat, lon));
      saveAllWeatherInfoToLoacl();
    });
  }

  // 使用 _fetchData 函数获取天气数据
  Future<void> loadWeatherDataByCityName(String cityName) async {
    await _fetchData(() async {
      final geoapiService = GetIt.I<GeoapiService>();
      final weatherService = GetIt.I<WeatherService>();
      _geoInfo = await geoapiService.getCurrentGeoIDByCityName(cityName);
      _weatherInfo = await weatherService
          .getCityWeatherNowByGeoID(_geoInfo!.location[0].id);
      _airInfo =
          await weatherService.getCityAirByGeoID(_geoInfo!.location[0].id);
      _the7dayWeather =
          await weatherService.get7DayWeatherByGeoID(_geoInfo!.location[0].id);

      saveAllWeatherInfoToLoacl();
      // await saveState();
    });
  }

  // 更新 geoInfo 并通知监听器
  Future<void> updateGeoInfo(GeoInfo city) async {
    _geoInfo = city;
    await loadWeatherDataByCityName(city.location[0].name);
    // await saveGeoInfoToLocal();
    notifyListeners();
  }

  void updateThemeMode(bool isDark) {
    _isDarkMode = isDark;
    GetIt.I.get<SharedPreferences>().setBool(ISDARKMODE, isDark);
    notifyListeners();
  }

  Future<void> updateSavedCities(List<GeoInfo> cities) async {
    _savedCities = cities;

    await saveSavedCitiesToLocal();
    notifyListeners();
  }

  Future<void> loadAllSavedData() async {
    // var prefs = await SharedPreferences.getInstance();
    var prefs = GetIt.I.get<SharedPreferences>();
    var savedCities = prefs.getStringList(SAVEDCITIES);
    if (savedCities != null) {
      _savedCities =
          savedCities.map((e) => GeoInfo.fromJson(jsonDecode(e))).toList();
    }
    var geoInfoStr = prefs.getString(GEOINFO);
    if (geoInfoStr != null) {
      _geoInfo = GeoInfo.fromJson(jsonDecode(geoInfoStr));
      // await loadWeatherDataByCityName(_geoInfo!.location[0].name);
    }
    var curWeatherInfoStr = prefs.getString(CURWEATHERINFO);
    if (curWeatherInfoStr != null) {
      _weatherInfo = CurWeatherInfo.fromJson(jsonDecode(curWeatherInfoStr));
    }

    var airInfoStr = prefs.getString(AIRINFO);
    if (airInfoStr != null) {
      _airInfo = AirInfo.fromJson(jsonDecode(airInfoStr));
    }

    var the7dayWeatherStr = prefs.getString(THE7DAYWEATHER);
    if (the7dayWeatherStr != null) {
      _the7dayWeather = The7DayWeather.fromJson(jsonDecode(the7dayWeatherStr));
    }

    var isDarkMode = prefs.getBool(ISDARKMODE);
    if (isDarkMode != null) {
      _isDarkMode = isDarkMode;
    }

    var selectedCityCardIndex = prefs.getInt(SELECTEDCITYCARDINDEX);
    if (selectedCityCardIndex != null) {
      _selectedCityCardIndex = selectedCityCardIndex;
    }

    var autoGetLocation = prefs.getBool(AUTOGETLOCATION) ?? false;
    _autoGetLocation = autoGetLocation;

    notifyListeners();
  }

  Future<void> saveState() async {
    await saveSavedCitiesToLocal();
    await saveGeoInfoToLocal();
  }

  void updateSelectedCityCardIndex(int index) {
    _selectedCityCardIndex = index;
    GetIt.I.get<SharedPreferences>().setInt(SELECTEDCITYCARDINDEX, index);
    notifyListeners();
  }
}
