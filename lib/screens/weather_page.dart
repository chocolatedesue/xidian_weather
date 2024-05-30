import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:qweather_icons/qweather_icons.dart';
// import 'package:xidian_weather/model/geoPositon.dart';
// import 'package:xidian_weather/model/weatherInfo.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xidian_weather/screens/chat_page.dart';

// import 'package:xidian_weather/util/icon_map.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage> {
  bool isWaitLoading = false;

  final Map<String, IconData> pollutantIcons = {
    "O3": FontAwesomeIcons.smog,
    "PM2.5": FontAwesomeIcons.cloudRain,
    "PM10": FontAwesomeIcons.smoking,
    "NO2": FontAwesomeIcons.gasPump,
    "SO2": FontAwesomeIcons.gaugeSimple,
    "CO": FontAwesomeIcons.smoking,
  };

  Future<void> _refreshWeatherData(BuildContext context) async {
    if (GetIt.I.isRegistered<Position>()) {
      final geoPosition = GetIt.I<Position>();
      // final weatherProvider = Provider.of<WeatherProvider>w(context, listen: false);
      final weatherProvider =
          Provider.of<WeatherProvider>(context, listen: false);
      await weatherProvider.loadWeatherDataByLocation(
          geoPosition.latitude, geoPosition.longitude);
    }

    // ... (使用 weatherProvider 更新天气数据)
    setState(() {}); // 更新 UI
    isWaitLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    // if (isWaitLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weatherInfo = weatherProvider.weatherInfo;
    final geoInfo = weatherProvider.geoInfo;
    final airInfo = weatherProvider.airInfo;

    if (weatherInfo == null || geoInfo == null || airInfo == null) {
      // return const Center(child: CircularProgressIndicator()); // 显示加载指示器
      //   当前并未设置任何城市，显示提示信息
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '请到收藏页选择城市\n或右上角获取当前位置',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }

    // 获取天气状况文本
    final weatherText = weatherInfo.now.text;

    final weatherIcon = QWeatherIcons.getFilledIconWith(
        QWeatherIcons.getIconWith(weatherInfo.now.icon));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 城市信息 (强调)
            Text(
              "${geoInfo.location[0].adm1}, ${geoInfo.location[0].adm2}, ${geoInfo.location[0].name}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // // 日期和时间
            Text(
                // "数据观测时间: ${weatherInfo.updateTime}\n经度: ${geoInfo.location[0].lon} 纬度: ${geoInfo.location[0].lat}"),
                // 精度保持小数点两位, 对其文字表示
                "数据观测时间: ${weatherInfo.updateTime}\n经度: ${double.parse(geoInfo.location[0].lon).toStringAsFixed(2)}          纬度: ${double.parse(geoInfo.location[0].lat).toStringAsFixed(2)}"),

            // RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(text: "数据观测时间: ${weatherInfo.updateTime}\n"),
            //       TextSpan(
            //           text: "经度: ${double.parse(geoInfo.location[0].lon).toStringAsFixed(2)} " +
            //               "             " +
            //               "纬度: ${double.parse(geoInfo.location[0].lat).toStringAsFixed(2)}",
            //           style: TextStyle(height: 1.5)), // Adjust height as needed
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            // 中间：天气图标、温度和状况 (使用 Card 和 Flexible)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        flex: 1,
                        // child: Icon(weatherIcon, size: 80),
                        // child: Icon(weatherIcon.iconData, size: 50),
                        child: Column(
                          children: [
                            // Icon(weatherIcon.iconData, size: 50),
                            Icon(weatherIcon.iconData, size: 50),
                            const SizedBox(height: 10),
                            Text(weatherText,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        )),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          // Icon(Icons.thermostat, size: 50), // 显示温度图标
                          Text('当前温度 ${weatherInfo.now.temp}°C'), // 显示当前温度
                          const SizedBox(height: 10),
                          Text(
                              '体感温度: ${weatherInfo.now.feelsLike}°C'), // 显示体感温度
                          // Text(weatherInfo.now.text), // 显示天气状况
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 底部：风、湿度、降雨概率和空气质量 (使用 Card)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.wind_power),
                        const SizedBox(height: 10),
                        Text(
                            '${weatherInfo.now.windDir} ${weatherInfo.now.windScale}级'), // 显示风向和风力
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.water_drop),
                        const SizedBox(height: 10),
                        Text('${weatherInfo.now.humidity}%'), // 显示湿度
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(Icons.air),
                        const SizedBox(height: 10),
                        Text('AQI: ${airInfo.now.aqi}'), // 显示 AQI
                        // Text(airInfo.now.category), // 显示空气质量类别
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 污染水平
            // Column(children: [],)
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("空气质量: ${airInfo.now.category}",
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            pollutantIcons.containsKey("O3")
                                ? Icon(pollutantIcons["O3"])
                                : const Icon(Icons.air),
                            const SizedBox(height: 10),
                            Text('PM2.5: ${airInfo.now.pm2P5}'), // 显示 PM2.5
                          ],
                        ),
                        Column(
                          children: [
                            pollutantIcons.containsKey("PM2.5")
                                ? Icon(pollutantIcons["PM2.5"])
                                : const Icon(Icons.air),
                            const SizedBox(height: 10),
                            Text('PM10: ${airInfo.now.pm10}'), // 显示 PM10
                          ],
                        ),
                        Column(
                          children: [
                            pollutantIcons.containsKey("PM10")
                                ? Icon(pollutantIcons["PM10"])
                                : const Icon(Icons.air),
                            const SizedBox(height: 10),
                            Text('NO2: ${airInfo.now.no2}'), // 显示 NO2
                          ],
                        ),
                        Column(
                          children: [
                            pollutantIcons.containsKey("NO2")
                                ? Icon(pollutantIcons["NO2"])
                                : const Icon(Icons.air),
                            const SizedBox(height: 10),
                            Text('SO2: ${airInfo.now.so2}'), // 显示 SO2
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
