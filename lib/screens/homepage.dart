// import 'package:dynamic_color/dynamic_color.dart';
// import 'dart:io';

// import 'dart:isolate';
// import 'package:get/get.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_city_picker/city_picker.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:toastification/toastification.dart';
import 'package:xidian_weather/screens/forecast_page.dart';
import 'package:xidian_weather/screens/save_page.dart';
import 'package:xidian_weather/screens/weather_page.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';
import 'package:xidian_weather/util/apiTest.dart';
import 'package:xidian_weather/util/const.dart';
// import 'package:synchronized/synchronized.dart';
// import 'weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  // bool firstLoading = false;
  bool isloading = false;

  Future<void> _getCurrentLocation(
      BuildContext context, WeatherProvider provider, bool showToast) async {
    await Permission.location.onDeniedCallback(() {
      toastification.show(
        context: context,
        title: const Text('错误, 位置权限已拒绝'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }).onGrantedCallback(() async {
      toastification.show(
        context: context,
        title: const Text('已获取位置权限，正在获取位置信息'),
        autoCloseDuration: const Duration(seconds: 5),
      );
      await Geolocator.getCurrentPosition().then((value) async {
        isloading = true;
        setState(() {});
        await Geolocator.getCurrentPosition().then((value) {
          provider.loadWeatherDataByLocation(value.latitude, value.longitude);
        });
        isloading = false;
        setState(() {});
      }).onError((error, stackTrace) {
        isloading = false;
        setState(() {});
        toastification.show(
          context: context,
          title: Text('获取位置信息失败, 请检查定位是否打开\n错误信息: $error'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      });

      // Your code
    }).onPermanentlyDeniedCallback(() {
      toastification.show(
        context: context,
        title: const Text('错误, 位置权限已永久拒绝'),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // Your code
    }).onRestrictedCallback(() {
      toastification.show(
        context: context,
        title: const Text('错误, 位置权限已限制'),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // Your code
    }).onLimitedCallback(() {
      toastification.show(
        context: context,
        title: const Text('错误, 位置权限已限制'),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // Your code
    }).onProvisionalCallback(() {
      toastification.show(
        context: context,
        title: const Text('正在获取位置权限'),
        autoCloseDuration: const Duration(seconds: 5),
      );

      // Your code
    }).request();
  }

  final _widgetOptions = <Widget>[
    const WeatherPage(),
    const ForecastPage(),
    const SavePage(),
  ];

  // get _isChecked => null;

  Future<void> _refreshWeatherData(BuildContext context) async {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    if (weatherProvider.geoInfo != null) {
      toastification.show(
        context: context,
        title: const Text('正在刷新天气信息'),
        autoCloseDuration: const Duration(seconds: 2),
      );
      // final geoPosition = GetIt.I.get<Position>();
      await weatherProvider
          .loadWeatherDataByLocation(
              double.parse(weatherProvider.geoInfo!.location[0].lat),
              double.parse(weatherProvider.geoInfo!.location[0].lon))
          .then((value) {
        toastification.show(
          context: context,
          title: const Text('刷新成功'),
          autoCloseDuration: const Duration(seconds: 2),
        );
      });
    } else {
      toastification.show(
        context: context,
        title: const Text('错误, 位置信息未获取，请先定位或手动选择城市'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }

    // weatherProvider.loadWeatherDataByLocation(lat, lon)
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        // if (isloading) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        return Scaffold(
          appBar: AppBar(
            title: const Text('西电天气-雾霾检测'),
            centerTitle: true,
            // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            actions: [
              // 使用 PopupMenuButton 创建下拉菜单
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert), // 使用 "..." 图标
                onSelected: (String choice) async {
                  switch (choice) {
                    case '刷新':
                      var weatherService = GetIt.I.get<WeatherService>();
                      await weatherService.checkAuthKey().then((value) {
                        if (!value) {
                          toastification.show(
                            context: context,
                            title: const Text('错误, 请先设置 API Key'),
                            autoCloseDuration: const Duration(seconds: 5),
                          );
                          return;
                        } else {
                          _refreshWeatherData(context);
                        }
                      });

                      // if (!await weatherService.checkAuthKey()) {
                      //   toastification.show(
                      //     context: context,
                      //     title: const Text('错误, 请先设置 API Key'),
                      //     autoCloseDuration: const Duration(seconds: 5),
                      //   );
                      //   return;
                      // }

                      // _refreshWeatherData(context);
                      break;
                    case '定位':
                      var weatherService = GetIt.I.get<WeatherService>();
                      await weatherService.checkAuthKey().then((value) {
                        if (!value) {
                          toastification.show(
                            context: context,
                            title: const Text('错误, 请先设置 API Key'),
                            autoCloseDuration: const Duration(seconds: 5),
                          );
                          return;
                        } else {
                          _getCurrentLocation(context, weatherProvider, true);
                        }
                      });

                      // if (!await weatherService.checkAuthKey()) {
                      //   toastification.show(
                      //     context: context,
                      //     title: const Text('错误, 请先设置 API Key'),
                      //     autoCloseDuration: const Duration(seconds: 5),
                      //   );
                      //   return;
                      // }
                      // _getCurrentLocation(context, weatherProvider, true);
                      break;
                    case '切换主题':
                      {
                        // sleep(Duration(microseconds: 300));
                        var theme = AdaptiveTheme.of(context).mode;
                        if (theme == AdaptiveThemeMode.light) {
                          AdaptiveTheme.of(context).setDark();
                          GetIt.I
                              .get<SharedPreferences>()
                              .setBool(ISDARKMODE, true);
                        } else {
                          AdaptiveTheme.of(context).setLight();
                          GetIt.I
                              .get<SharedPreferences>()
                              .setBool(ISDARKMODE, false);
                        }
                      }
                      break;
                    case '关于':
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('关于'),
                            content: const Text(
                                '这是一个基于 Flutter 的天气应用, 调用了和风天气的 API\n作者邮件: chocolatedesue@outlook.com'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('确定'),
                              ),
                            ],
                          );
                        },
                      );
                      break;
                    case '设置':
                      showDialog(
                        context: context,
                        builder: (context) {
                          String apiKey = '';
                          return StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return AlertDialog(
                                title: const Text('设置'),
                                content: TextField(
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    labelText:
                                        '请输入和风天气的 API Key \n可到 https://dev.qweather.com/docs/api/ 查看文档',
                                  ),
                                  onChanged: (value) {
                                    apiKey = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      if (apiKey.isEmpty) {
                                        toastification.show(
                                          context: context,
                                          title: const Text('API Key 不能为空'),
                                        );
                                        return;
                                      }
                                      // if (!await ApiTest.testApikey(apiKey)) {
                                      //   toastification.show(
                                      //     context: context,
                                      //     title: const Text('API Key 无效'),
                                      //   );
                                      //   return;
                                      // }
                                      await ApiTest.testApikey(apiKey)
                                          .then((value) {
                                        if (!value) {
                                          toastification.show(
                                            context: context,
                                            title: const Text('API Key 无效'),
                                          );
                                          return;
                                        }
                                      });

                                      GetIt.I
                                          .get<WeatherService>()
                                          .updateAuthKey(apiKey);
                                      GetIt.I
                                          .get<GeoapiService>()
                                          .updateAuthKey(apiKey);
                                      await const FlutterSecureStorage()
                                          .write(key: QWEATHERAPIKEY, value: apiKey)
                                          .then((value) {
                                        toastification.show(
                                          context: context,
                                          title: const Text('设置成功'),
                                        );
                                        Navigator.of(context).pop();
                                      });

                                      // Navigator.of(context).pop();
                                    },
                                    child: const Text('确定'),
                                  ),
                                  // 添加取消
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('取消'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                      break;
                    case '自动获取位置':
                      {
                        // 更新状态
                        // setState(() {
                        //   weatherProvider.updateAutoGetLocation(
                        //       !weatherProvider.autoGetLocation);
                        // });
                      }
                      break;

                    default:
                      // print('Unknown choice: $choice');
                      toastification.show(
                        context: context,
                        title: Text('未知选项: $choice'),
                      );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: '刷新',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 10),
                          Text('刷新'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
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
                          if (AdaptiveTheme.of(context).mode ==
                              AdaptiveThemeMode.light)
                            const Icon(Icons.dark_mode)
                          else
                            const Icon(Icons.light_mode),
                          const SizedBox(width: 10),
                          const Text('切换主题'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: '设置',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 10),
                          Text('设置API Key'),
                        ],
                      ),
                    ),
                    // PopupMenuItem<String>(
                    //   value: '自动获取位置',
                    //   child: StatefulBuilder(
                    //     builder: (BuildContext context, StateSetter setState) {
                    //       return CheckboxListTile(
                    //         title: const Text('自动获取位置'),
                    //         secondary: const Icon(Icons.auto_mode),
                    //         value: weatherProvider.autoGetLocation,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             weatherProvider.updateAutoGetLocation(value!);
                    //             // GetIt.I
                    //             //     .get<SharedPreferences>()
                    //             //     .setBool(AUTOLOCATION, value);
                    //           });
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                    const PopupMenuItem<String>(
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
          body: isloading
              ? const Center(child: CircularProgressIndicator())
              : _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '详情',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud),
                label: '预测',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: '收藏',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
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
}
