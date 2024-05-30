import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:xidian_weather/model/airInfo.dart';
import 'package:xidian_weather/model/cur_weatherInfo.dart';
import 'package:xidian_weather/provider/weather_provider.dart';
import 'package:xidian_weather/util/const.dart';
import 'package:xidian_weather/util/icon_map.dart';

class DashscopeAPI {
  final String apiKey;
  final String baseUrl =
      'https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation';

  final Dio _dio = Dio();

  DashscopeAPI({required this.apiKey}) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<String> sendMessage(
      String message, CurWeatherInfo weatherInfo, AirInfo airInfo,
      {List<Map<String, String>>? history}) async {
    var messages = history != null ? [...history] : [];

    // final weatherProvider = Provider.of<WeatherProvider>(context);

    // final weather_data = "天气数据如下\n${GetIt.instance.get<CurWeatherInfo>().toJson()}\n${GetIt.instance.get<AirInfo>().toJson()}\n";

    final weather_data =
        "天气数据如下\n${weatherInfo.toJson()}\n${airInfo.toJson()}\n";

    messages.addAll([
      {"role": "system", "content": SYSTEM_SETTING},
      {"role": "system", "content": DATA_DESCRIPT_INFO},
      {"role": "system", "content": weather_data},
      {"role": "user", "content": message},
    ]);

    if (kDebugMode) {
      print("Start to send message: $message");
    }

    var response = await _dio.post(
      baseUrl,
      data: jsonEncode({
        "model": "qwen-turbo",
        "input": {"messages": messages},
        "parameters": {"result_format": "message"}
      }),
    );

    if (response.statusCode == 200) {
      var data = response.data;
      if (kDebugMode) {
        print("Body: ${response.data}");
      }
      return data['output']['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  Stream<String> streamMessage(String message,
      {List<Map<String, String>>? history}) async* {
    var messages = history != null ? [...history] : [];
    messages.addAll([
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": message},
    ]);

    var response = await _dio.post(
      baseUrl,
      data: jsonEncode({
        "model": "qwen-turbo",
        "input": {"messages": messages},
        "parameters": {"incremental_output": true, "result_format": "message"}
      }),
      options: Options(
        responseType: ResponseType.stream, // 指定响应类型为stream
        headers: {'X-DashScope-SSE': 'enable'},
      ),
    );

    if (response.statusCode == 200) {
      await for (var chunk in response.data.stream) {
        // 处理流式数据
        String dataString = utf8.decode(chunk);
        var lines = dataString.split('\n');
        for (var line in lines) {
          if (line.trim().isNotEmpty) {
            try {
              var jsonData = jsonDecode(line.substring(5));
              yield jsonData['output']['choices'][0]['message']['content'];
            } catch (e) {
              // 处理不完整的JSON块
              print("Error decoding JSON: $e");
            }
          }
        }
      }
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }
}
