import 'dart:convert';

// import 'package:dynamic_color/dynamic_color.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
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
// import 'package:xidian_weather/theme/app_theme.dart';

// bool _isDemoUsingDynamicColors = false;

// Fictitious brand color.
const _brandBlue = Color(0xFF1E88E5);

// CustomColors lightCustomColors = const CustomColors(danger: Color(0xFFE53935));
// CustomColors darkCustomColors = const CustomColors(danger: Color(0xFFEF9A9A));
// import 'package:geolocator/geolocator.dart';
void main() async {
  await setupData();
  // await DynamicColorPlugin.initialize();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var prefs = GetIt.I<SharedPreferences>();
    var themeMode =
        prefs.getBool('darkMode') ?? ThemeMode.system == ThemeMode.dark
            ? AdaptiveThemeMode.dark
            : AdaptiveThemeMode.light;

    return ChangeNotifierProvider(
        create: (context) => GetIt.I<WeatherProvider>(),
        child: AdaptiveTheme(
          light: ThemeData.light(useMaterial3: true),
          dark: ThemeData.dark(useMaterial3: true),
          initial: themeMode,
          builder: (theme, darkTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: darkTheme,
            home: const HomePage(),
          ),
        ));
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

  GetIt.I.registerSingleton<WeatherProvider>(
    WeatherProvider(),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  GetIt.I.registerSingleton<SharedPreferences>(prefs);

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
}
