import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:xidian_weather/screens/homepage.dart';
import 'package:xidian_weather/service/geoapi_service.dart';
import 'package:xidian_weather/service/weatherapi_service.dart';
import 'package:xidian_weather/theme/app_theme.dart';
// import 'package:geolocator/geolocator.dart';
void main() async {
  
  setupData();
  runApp(const MyApp());
}

Future<void> setupData() async {
  // setup data
  WidgetsFlutterBinding.ensureInitialized();
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

        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: HomePage()),
    
    );  

    
  }
}
