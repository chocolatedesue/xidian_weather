import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
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
  setupData();
  // await DynamicColorPlugin.initialize();

  runApp(const MyApp());
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

  // Position position =
  // GetIt.I.registerSingleton<Position>(position);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  build a weather app

    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            // On Android S+ devices, use the provided dynamic color scheme.
            // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
            lightColorScheme = lightDynamic.harmonized();
            // (Optional) Customize the scheme as desired. For example, one might
            // want to use a brand color to override the dynamic [ColorScheme.secondary].
            lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
            // (Optional) If applicable, harmonize custom colors.
            // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

            // Repeat for the dark color scheme.
            darkColorScheme = darkDynamic.harmonized();
            darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
            // darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

            _isDemoUsingDynamicColors = true; // ignore, only for demo purposes
          } else {
            // Otherwise, use fallback schemes.
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: _brandBlue,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: _brandBlue,
              brightness: Brightness.dark,
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather App',
            theme: ThemeData(colorScheme: lightColorScheme),
            darkTheme: ThemeData(colorScheme: darkColorScheme),
            themeMode: ThemeMode.system,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
