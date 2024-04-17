// import 'package:dynamic_color/dynamic_color.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_city_picker/city_picker.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:xidian_weather/screens/forecast_page.dart';
import 'package:xidian_weather/screens/save_page.dart';
import 'package:xidian_weather/screens/weather_page.dart';
// import 'package:synchronized/synchronized.dart';
// import 'weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Color? backgroundColor;

  // Create a tab controller
  // late TabController controller;

  int _selectedIndex = 0;

  final _widgetOptions = <Widget>[
    WeatherPage(),
    ForecastPage(),
    SavePage(),
  ];

  Future<void> _refreshWeatherData(BuildContext context) async {
    // TODO: 在这里执行刷新操作，例如重新获取天气数据
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    // ... (使用 weatherProvider 更新天气数据)
    if (GetIt.I.isRegistered<Position>()) {
      toastification.show(
        context: context,
        title: Text('正在刷新天气信息'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      final geoPosition = GetIt.I.get<Position>();
      await weatherProvider.loadWeatherDataByLocation(
          geoPosition.latitude, geoPosition.longitude);
      toastification.show(
        context: context,
        title: Text('刷新成功'),
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.show(
        context: context,
        title: Text('错误, 位置信息未获取'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }

    // weatherProvider.loadWeatherDataByLocation(lat, lon)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        return Scaffold(

          // themeMode: weatherProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          appBar: AppBar(
            title: const Text('Weather App'),
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            actions: [
              // 使用 PopupMenuButton 创建下拉菜单
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert), // 使用 "..." 图标
                onSelected: (String choice) {
                  if (choice == '刷新') {
                    _refreshWeatherData(context);
                  } else if (choice == '定位') {
                    _getCurrentLocation(context, weatherProvider);
                  } else if ( choice == "切换主题") {
                    weatherProvider.updateThemeMode(
                        !weatherProvider.isDarkMode
                    );
                  } else if (choice == '关于') {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('关于'),
                          content: Text('这是一个天气应用'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('确定'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: '刷新',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 10),
                          Text('刷新'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '定位',
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 10),
                          Text('定位'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: '切换主题',
                      child: Row(
                        children: [
                          // Icon(Icons.light_mode),
                          // Text('切换主题'),
                          if (weatherProvider.isDarkMode)
                            Icon(Icons.light_mode)
                          else
                            Icon(Icons.dark_mode),
                          // Icon(Icons.),
                          SizedBox(width: 10),
                          if (weatherProvider.isDarkMode)
                            Text('切换到白天模式')
                          else
                            Text('切换到夜间模式'),
                        ],
                      ),
                    ),

                    PopupMenuItem<String>(
                      value: '关于',
                      child: Row(
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 10),
                          Text('关于'),
                        ],
                      ),
                    ),

                  ];
                },
              ),
            ],
          ),
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud),
                label: 'forecast',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                label: 'save',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getCurrentLocation(
      BuildContext context, WeatherProvider provider) async {
    if (GetIt.I.isRegistered<Position>()) {
      // print ("位置信息已获取");
      //   toastification.show(
      //     context: context,
      //     title: Text('位置信息已获取, 无需重复获取'),
      //     autoCloseDuration: const Duration(seconds: 5),
      //   );
      var position = GetIt.I.get<Position>();

      toastification.show(
        context: context,
        title: Text('定位成功, 正在获取天气信息'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      await provider.loadWeatherDataByLocation(
          position.latitude, position.longitude);

      return;
    }

    // print("开始获取位置信息");
    toastification.show(
      context: context,
      title: Text('正在获取位置信息'),
      autoCloseDuration: const Duration(seconds: 5),
    );

    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("位置服务已禁用");
      toastification.show(
        context: context,
        title: Text('错误, 位置服务已禁用，请启用位置服务后重启应用'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("位置权限已拒绝");
        toastification.show(
          context: context,
          title: Text('错误, 位置权限已拒绝'),
          autoCloseDuration: const Duration(seconds: 5),
        );

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("位置权限已永久拒绝");
      toastification.show(
        context: context,
        title: Text('错误, 位置权限已永久拒绝'),
        autoCloseDuration: const Duration(seconds: 5),
      );

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print("successfully get location");

    var position = await Geolocator.getCurrentPosition();
    // GetIt.I<GeoapiService>().getCityName(position.latitude, position.longitude);
    GetIt.I.registerSingleton<Position>(position);

    toastification.show(
      context: context,
      title: Text('定位成功, 正在获取天气信息'),
      autoCloseDuration: const Duration(seconds: 2),
    );

    await provider.loadWeatherDataByLocation(
        position.latitude, position.longitude);
  }
}
