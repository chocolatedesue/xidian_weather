

// class ApiService {
//   final Dio _dio = Dio();
// //  使用和风天气
//   final String _baseUrl = 'https://devapi.qweather.com/v7/weather';
//   String apiKey = '';


//   void init (){
//     _dio.options.baseUrl = _baseUrl;
//   // read apikey from env or config file
    
//   }


//   Future<Map<String, dynamic>> getWeather(String city) async {
//     try {
//       final response = await _dio.get(
//         'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=YOUR_API_KEY',
//       );
//       return response.data;
//     } catch (e) {
//       return {};
//     }
//   }
// }