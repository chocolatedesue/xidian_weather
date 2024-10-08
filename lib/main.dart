// import 'package:dynamic_color/dynamic_color.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xidian_weather/env/envied.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:xidian_weather/screens/homepage.dart';
import 'package:xidian_weather/service/chat_service.dart';
import 'package:xidian_weather/service/dashscopeService.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';
// import 'package:xidian_weather/util/apiTest.dart';
// import 'package:xidian_weather/theme/app_theme.dart';
import 'package:xidian_weather/util/const.dart';
// import 'package:xidian_weather/theme/app_theme.dart';
// import 'package:xidian_weather/theme/app_theme.dart';

// bool _isDemoUsingDynamicColors = false;

// Fictitious brand color.
// const _brandBlue = Color(0xFF1E88E5);

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
        prefs.getBool(ISDARKMODE) ?? ThemeMode.system == ThemeMode.dark
            ? AdaptiveThemeMode.dark
            : AdaptiveThemeMode.light;
    var lightTheme = ThemeData.light(useMaterial3: true)
        .useSystemChineseFont(Brightness.light);
    var darkTheme = ThemeData.dark(useMaterial3: true)
        .useSystemChineseFont(Brightness.dark);

    return ChangeNotifierProvider(
        create: (context) => GetIt.I<WeatherProvider>(),
        child: AdaptiveTheme(
          light: lightTheme,
          dark: darkTheme,
          initial: themeMode,
          builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const HomePage(),
              theme: theme,
              darkTheme: darkTheme),
        ));
  }
}

Future<void> setupData() async {
  // setup data
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // await DynamicColorPlugin.initial();

  GetIt.I.registerSingleton<WeatherProvider>(
    WeatherProvider(),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  //  use flutter_secure_storage to read and write the api key
  const storage = FlutterSecureStorage();

  String QweatherApiKey = await storage.read(key: QWEATHERAPIKEY) ?? '';
  if (QweatherApiKey.isEmpty) {
    QweatherApiKey = Env.QWEATHER_APIKEY;
    await storage.write(key: QWEATHERAPIKEY, value: QweatherApiKey);
  }

  GetIt.I.registerSingleton<WeatherService>(
    WeatherService(QweatherApiKey),
  );
  GetIt.I.registerSingleton<GeoapiService>(
    GeoapiService(QweatherApiKey),
  );

  // String googleStudioApiKey = await storage.read(key: GOOGLESTUDIOAPIKEY) ?? '';
  // if (googleStudioApiKey.isEmpty) {
  //   googleStudioApiKey = Env.GOOGLE_STUDIO_API_KEY;
  //   await storage.write(key: GOOGLESTUDIOAPIKEY, value: googleStudioApiKey);
  // }

  // GetIt.I.registerSingleton<ChatService>(
  //   // WeatherService(QweatherApiKey),
  //   ChatService(googleStudioApiKey),
  // );

  String DashScopeApiKey = await storage.read(key: DASHSCOPEAPIKEY) ?? '';
  if (DashScopeApiKey.isEmpty) {
    DashScopeApiKey = Env.DASHSCOPE_APIKEY;
    await storage.write(key: DASHSCOPEAPIKEY, value: DashScopeApiKey);
  }

  GetIt.I.registerSingleton<DashscopeAPI>(
    DashscopeAPI(apiKey: DashScopeApiKey),
  );


  await GetIt.I.get<WeatherProvider>().loadAllSavedData();

  // var savedCityStrList = prefs.getStringList(SAVEDCITIES);
  // if (savedCityStrList != null) {

  // }
}
