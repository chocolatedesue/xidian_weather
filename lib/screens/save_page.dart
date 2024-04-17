import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
// 引入本地存储相关库
import 'package:xidian_weather/service/geoapi_service.dart';

// ... 其他导入

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  // 记录当前选中的卡片索引，-1 表示未选中任何卡片
  // int _selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // await GetIt.I.get<WeatherProvider>().loadSavedCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('已保存的地址'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return ListView.builder(
            itemCount: weatherProvider.savedCities!.length,
            itemBuilder: (context, index) {
              final city = weatherProvider.savedCities![index];

              // var weatherProvider.selectedCityCardIndex = weatherProvider.weatherProvider.selectedCityCardIndex;
              return Card(
                color: weatherProvider.selectedCityCardIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                child: ListTile(
                  title: Text(
                      "${city.location[0].adm2} ${city.location[0].adm1} ${city.location[0].name}",
                      style: TextStyle(
                          fontSize: 20,
                          color: weatherProvider.selectedCityCardIndex == index
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSecondary)),
                  subtitle: Text(
                      "ID: ${city.location[0].id}\nlat: ${city.location[0].lat ?? '未知'} lon: ${city.location[0].lon ?? '未知'}",
                      style: TextStyle(
                          fontSize: 15,
                          color: weatherProvider.selectedCityCardIndex == index
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSecondary)),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: weatherProvider.selectedCityCardIndex == index
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondary,
                      onPressed: () {
                        // 弹出确认删除对话框
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('确认删除城市 ${city.location[0].name} 吗?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  var cityList = weatherProvider.savedCities;
                                  cityList!.removeAt(index);
                                  await weatherProvider
                                      .updateSavedCities(cityList);
                                  toastification.show(
                                    context: context,
                                    title: Text('已删除 ${city.location[0].name}'),
                                    autoCloseDuration:
                                        const Duration(seconds: 2),
                                  );
                                },
                                child: const Text('确定'),
                              ),
                            ],
                          ),
                        );

                        // var cityList = weatherProvider.savedCities;
                        // cityList!.removeAt(index);
                        // weatherProvider.updateSavedCities(cityList);
                        // toastification.show(
                        //   context: context,
                        //   title: Text('已删除 ${city.location[0].name}'),
                        //   autoCloseDuration: const Duration(seconds: 2),
                        // );
                      }),
                  onTap: () async {
                    if (weatherProvider.selectedCityCardIndex == index) {
                      toastification.show(
                        context: context,
                        title: const Text('已经是当前选中的城市了'),
                        autoCloseDuration: const Duration(seconds: 2),
                      );

                      return;
                    }

                    setState(() {
                      weatherProvider.updateSelectedCityCardIndex(index);
                    });

                    toastification.show(
                      context: context,
                      title: Text('成功切换地区到 ${city.location[0].name}, 正在刷新天气信息'),
                      autoCloseDuration: const Duration(seconds: 2),
                    );

                    await weatherProvider.updateGeoInfo(city);
                    // weatherProvider.loadWeatherDataByLocation(
                    //   double.parse(city.location[0].lat),
                    //   double.parse(city.location[0].lon),
                    // );
                  },
                ),
              );
            },
            // ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCityDialog(context), // 显示添加城市对话框
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddCityDialog(BuildContext context) async {
    final cityNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加城市'),
        content: TextField(
          controller: cityNameController,
          decoration: const InputDecoration(
            hintText: '请输入城市名称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              // 获取城市名称
              final cityName = cityNameController.text.trim();
              if (cityName.isNotEmpty) {
                final geoapiService = GetIt.I<GeoapiService>();
                try {
                  var geoInfo =
                      await geoapiService.getCurrentGeoIDByCityName(cityName);
                  var weatherProvider =
                      Provider.of<WeatherProvider>(context, listen: false);

                  weatherProvider.addCityToSavedCities(geoInfo);
                  // await weatherProvider.saveSavedCitiesToLocal();
                  // 关闭对话框并刷新页面
                  Navigator.pop(context);
                  // _refreshWeatherData(context);
                } catch (e) {
                  toastification.show(
                    context: context,
                    title: Text('添加城市失败: 可能是城市名称错误或网络问题\n$e'),
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                }
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
