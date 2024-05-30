// lib/env/env.dart
import 'package:envied/envied.dart';
// import 'package:xidian_weather/util/const.dart';

part 'envied.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'QWEATHER_APIKEY', obfuscate: true)
  static final String QWEATHER_APIKEY = _Env.QWEATHER_APIKEY;
  @EnviedField(varName: 'GOOGLE_STUDIO_API_KEY', obfuscate: true)
  static final String GOOGLE_STUDIO_API_KEY = _Env.GOOGLE_STUDIO_API_KEY;
  @EnviedField(varName: 'DASHSCOPE_APIKEY', obfuscate: true)
  static final String DASHSCOPE_APIKEY = _Env.DASHSCOPE_APIKEY;
}
