import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/model/geoInfo.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:xidian_weather/screens/homepage.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';
// import 'package:xidian_weather/theme/app_theme.dart';

bool _isDemoUsingDynamicColors = false;

// Fictitious brand color.
const _brandBlue = Color(0xFF1E88E5);

// CustomColors lightCustomColors = const CustomColors(danger: Color(0xFFE53935));
// CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));
// import 'package:geolocator/geolocator.dart';
void main() async {
  await setupData();
  // await DynamicColorPlugin.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather App',
          themeMode: ThemeMode.dark,
          home: HomePage(),
        );
      },
    );
  }
}



Future<void> setupData() async {
  // setup data
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // await DynamicColorPlugin.initial();
  String apiKey = 'a39653de05304df4a1aa614bba622fef';
  GetIt.I.registerSingleton<WeatherService>(
    WeatherService(apiKey),
  );
  GetIt.I.registerSingleton<GeoapiService>(
    GeoapiService(apiKey),
  );

  // GetIt.I.registerSingleton<WeatherProvider>(
  //   WeatherProvider(),
  // );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var positionStr = prefs.getString('position') ?? '';
  if (positionStr.isNotEmpty) {
    var positionJson = jsonDecode(positionStr);
    Position position = Position.fromMap(positionJson);
    GetIt.I.registerSingleton<Position>(position);
  }

  var savedCityStrList = prefs.getStringList('savedCityList');
  if (savedCityStrList != null) {
    var savedCityList = savedCityStrList.map((e) => jsonDecode(e)).toList();
    List<GeoInfo> savedCities =
        savedCityList.map((e) => GeoInfo.fromJson(e)).toList();
    GetIt.I<WeatherProvider>().updateSavedCities(savedCities);
  }

  // GetIt.I.registerSingleton<bool>(false);
  var isDarkMode =
      prefs.getBool('isDarkMode') ?? ThemeMode.system == ThemeMode.dark;
  // GetIt.I<WeatherProvider>().updateThemeMode(isDarkMode);
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//         create: (context) => WeatherProvider(),
//         builder: (context, child) {
//           // final weatherProvider = GetIt.I<WeatherProvider>();
//           // final weatherProvider = Provider.of<WeatherProvider>(context);
//           // var themeModeState = weatherProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light;
//           return const MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Weather App',
//             themeMode: ThemeMode.dark,
//             home: HomePage(),
//           );
//         });
//   }
// }
