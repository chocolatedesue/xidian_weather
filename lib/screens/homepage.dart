import 'package:flutter/material.dart';
import 'package:xidian_weather/service/weather_service.dart';
// import 'weather_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherService weatherService = WeatherService();
  String cityName = 'London'; // default city
  dynamic weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  fetchWeatherData() async {
    weatherData = await weatherService.getCityWeather(cityName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: weatherData != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Weather in $cityName: ${weatherData['main']['temp']}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
