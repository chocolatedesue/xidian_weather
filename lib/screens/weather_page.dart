import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
// import 'package:xidian_weather/model/geoPositon.dart';
// import 'package:xidian_weather/model/weatherInfo.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:xidian_weather/util/icon_map.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<void> _refreshWeatherData(BuildContext context) async {
    if (GetIt.I.isRegistered<Position>()) {
      final geoPosition = GetIt.I<Position>();
      // final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      await weatherProvider.loadWeatherDataByLocation(
          geoPosition.latitude, geoPosition.longitude);
    }

    // ... (使用 weatherProvider 更新天气数据)
    setState(() {}); // 更新 UI
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weatherInfo = weatherProvider.weatherInfo;
    final geoInfo = weatherProvider.geoInfo;
    final airInfo = weatherProvider.airInfo;

    if (weatherInfo == null || geoInfo == null || airInfo == null) {
      return Center(child: CircularProgressIndicator()); // 显示加载指示器
    }

    // 获取天气状况文本
    final weatherText = weatherInfo.now.text;

    // 查找图标
    final icon = weatherDescriptionMap.containsKey(weatherText)
        ? weatherDescriptionMap[weatherText]?.dayIcon ?? Icons.help_outline
        : Icons.help_outline;

    return RefreshIndicator(
      onRefresh: () => _refreshWeatherData(context), // 传递 context
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 城市信息 (强调)
            Text(
              geoInfo.location[0].name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // 日期和时间
            Text(weatherInfo.updateTime),
            SizedBox(height: 20),
            // 中间：天气图标、温度和状况 (使用 Card 和 Flexible)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Icon(icon, size: 80), // TODO: 根据天气状况显示图标
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(weatherInfo.now.temp + '°C'), // 显示当前温度
                          Text('最高: ' +
                              weatherInfo.now.feelsLike +
                              '°C'), // 显示体感温度
                          Text(weatherInfo.now.text), // 显示天气状况
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // 底部：风、湿度、降雨概率和空气质量 (使用 Card)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.wind_power),
                        Text(weatherInfo.now.windDir +
                            ' ' +
                            weatherInfo.now.windScale +
                            '级'), // 显示风向和风力
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.water_drop),
                        Text(weatherInfo.now.humidity + '%'), // 显示湿度
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.air),
                        Text('AQI: ${airInfo.now.aqi}'), // 显示 AQI
                        Text(airInfo.now.category), // 显示空气质量类别
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
