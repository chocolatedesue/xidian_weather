import 'package:flutter/material.dart';
import 'package:flutter_city_picker/city_picker.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:toastification/toastification.dart';

// import 'weather_service.dart';

class HomePage extends StatefulWidget   {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin implements CityPickerListener {

  
  /// 0: 省
  /// 1: 市
  /// 2: 地区
  /// 3: 街道
  // int _currentType = 0;
  // late AnimationController _animationController;



  @override
  void initState(){
    super.initState();
    // final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    // weatherProvider.loadWeatherData('Beijing');
    // Position position = GetIt.I<Position>();
    //  _animationController = AnimationController(
      // vsync: this,
      // duration: Duration(milliseconds: 200),
    // );  
 

  }

  

  
  @override
  Widget build(BuildContext context){
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child){
        return Scaffold(
          appBar: AppBar(
            title: const Text('Weather App'),
            centerTitle: true,
            backgroundColor:  Theme.of(context).appBarTheme.backgroundColor,
            actions: [
                IconButton(onPressed: () async {
                 await  _getCurrentLocation(context,weatherProvider );
                },
                 icon: Icon( GetIt.I.isRegistered<Position>() ? Icons.location_on : Icons.location_off,
                 color: Theme.of(context).iconTheme.color, )
                 ),
                IconButton(
                    onPressed: () {
                      // _bottomSheet();
                      // CityPicker.show(context: context, cityPickerListener: this);

                      showSearch(context: context, delegate: citySearchDelegate());

                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],

          ),

          body:  buildBody(weatherProvider, context),
        );
      },
    );
  }
  
  Widget buildBody (WeatherProvider weatherProvider,BuildContext  context){
    // try {
    //   var position = GetIt.I<Position>();
    //   weatherProvider.loadWeatherDataByLocation(position.latitude, position.longitude);
    // } catch (e) {
    //   print(e);
    // }



    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                // const Text('Enter City Name:'),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                     child: TextField(
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Enter City Name',
                      ),
                      onSubmitted: (value){
                        weatherProvider.loadWeatherDataByCityName(value);
                      },
                    
                    ),
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
          );
  }
  
  Future<void> _getCurrentLocation(BuildContext context, WeatherProvider provider  ) async {
    if (GetIt.I.isRegistered<Position>()) {

      // print ("位置信息已获取");
      //   toastification.show(
      //     context: context,
      //     title: Text('位置信息已获取, 无需重复获取'),
      //     autoCloseDuration: const Duration(seconds: 5),
      //   );
        var position = GetIt.I.get<Position>();
        provider.loadWeatherDataByLocation(
        position.latitude, position.longitude);
        
        return ;
    }

    print ("开始获取位置信息");

   LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
   if (!serviceEnabled) {
        // setState(() {
        //   isError = true;
        //   error =
        //       "Location services are disabled & then restart the application!";
        // });
        print ("位置服务已禁用");
      toastification.show(
          context: context,
          title: Text('错误, 位置服务已禁用，请启用位置服务后重启应用'),
          autoCloseDuration: const Duration(seconds: 5),
        );
   }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      print ("位置权限已拒绝");
       toastification.show(
          context: context,
          title: Text('错误, 位置权限已拒绝'),
          autoCloseDuration: const Duration(seconds: 5),
        );

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print ("位置权限已永久拒绝");
      toastification.show(
          context: context,
          title: Text('错误, 位置权限已永久拒绝'),
          autoCloseDuration: const Duration(seconds: 5),
        );

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    print ("successfully get location");


    var position = await Geolocator.getCurrentPosition();
    // GetIt.I<GeoapiService>().getCityName(position.latitude, position.longitude);
    GetIt.I.registerSingleton<Position>(position);

    provider.loadWeatherDataByLocation(
        position.latitude, position.longitude);
    
    toastification.show(
          context: context,
          title: Text('成功获取位置信息'),
          autoCloseDuration: const Duration(seconds: 5),
        );
  
  }
 

 
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}







class citySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
  


  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  //  @override
  // PreferredSizeWidget buildAppBar(BuildContext context) {
  //   return AppBar(
  //     title: TextField(
  //       controller: TextEditingController(text: "输入你要查找的城市"), // Set initial value
  //       autofocus: true,
  //       decoration: InputDecoration(
  //         hintText: "输入你要查找的城市", // Placeholder text
  //         border: InputBorder.none,
  //       ),
  //       onChanged: (query) {
  //         query = query.toLowerCase();
  //         // ... Update suggestions based on query ...
  //       },
  //     ),
  //     // ... Other AppBar elements ...
  //   );
  // }
}