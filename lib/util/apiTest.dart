import 'package:dio/dio.dart';

class ApiTest {
  static const String BASE_URL = "https://geoapi.qweather.com/v2";

  static testApikey(String apiKey) async {
    var url = '$BASE_URL/city/lookup?location=beij&key=$apiKey';
    try {
      var response = await  Dio().get(url);

      if (response.statusCode == 200 &&  response.data['code'] == '200') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
