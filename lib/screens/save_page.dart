import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
// 引入本地存储相关库
import 'package:shared_preferences/shared_preferences.dart';

// ... 其他导入

class SavePage extends StatefulWidget {
  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  // 添加下拉刷新控制器
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshWeatherData(BuildContext context) async {
    // 使用下拉刷新控制器显示加载指示器
    _refreshIndicatorKey.currentState?.show();
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    // 从本地存储获取 savedCities 数据
    // await weatherProvider.fetchSavedCitiesFromLocal();
    // TODO: 在这里执行刷新操作，例如重新获取天气数据
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已保存的地址'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          // 使用 RefreshIndicator 实现下拉刷新
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () => _refreshWeatherData(context),
            child: ListView.builder(
              itemCount: weatherProvider.savedCities.length,
              itemBuilder: (context, index) {
                final city = weatherProvider.savedCities[index];
                return Card(
                  child: ListTile(
                    title: Text(city.location[0].name ?? '未知',
                        style: TextStyle(fontSize: 20, color: Colors.red)),
                    subtitle: Text(
                        "ID: ${city.location[0].id}\nlat: ${city.location[0].lat ?? '未知'} lon: ${city.location[0].lon ?? '未知'}",
                        style: TextStyle(fontSize: 15, color: Colors.blue)),
                    onTap: () {
                      // 更新 geoInfo 并加载天气数据
                      weatherProvider.updateGeoInfo(city);
                      weatherProvider.loadWeatherDataByLocation(
                        double.parse(city.location[0].lat!),
                        double.parse(city.location[0].lon!),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCityDialog(context), // 显示添加城市对话框
        child: Icon(Icons.add),
      ),
    );

  }

  Future<void> _showAddCityDialog(BuildContext context) async {
    final _cityNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('添加城市'),
        content: TextField(
          controller: _cityNameController,
          decoration: InputDecoration(
            hintText: '请输入城市名称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              // 获取城市名称
              final cityName = _cityNameController.text.trim();
              if (cityName.isNotEmpty) {
                // 加载城市信息并更新 savedCities
                final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
                await weatherProvider.loadWeatherDataByCityName(cityName);
                if (weatherProvider.geoInfo != null) {
                  // 将新城市添加到 savedCities 并保存到本地存储
                  weatherProvider.addCityToSavedCities(weatherProvider.geoInfo!);
                  await weatherProvider.saveSavedCitiesToLocal();
                  // 关闭对话框并刷新页面
                  Navigator.pop(context);
                  _refreshWeatherData(context);
                }
              }
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }
}