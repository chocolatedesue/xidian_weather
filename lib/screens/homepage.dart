import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xidian_weather/provider/weather_provider.dart';

// import 'weather_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context){
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child){
        return Scaffold(
          appBar: AppBar(
            title: const Text('Weather App'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Enter City Name:'),
                Center(
                  child: TextField(
                    onSubmitted: (value){
                      weatherProvider.loadWeatherData(value);
                    },
                  ),
                ),
                if(weatherProvider.isLoading)
                  const CircularProgressIndicator()
                else if(weatherProvider.error.isNotEmpty)
                  Text(weatherProvider.error)
                else if(weatherProvider.weatherInfo != null)
                  Column(
                    children: [
                      Text('City: ${weatherProvider.geoInfo!.cityName}'),
                      Text('Temperature: ${weatherProvider.weatherInfo!.temperature}'),
                      Text('Weather: ${weatherProvider.weatherInfo!.description}'),
                      Text('Air Quality: ${weatherProvider.airInfo!.now.aqi}'),
                      
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );

  }
    
}

