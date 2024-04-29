// lib/env/env.dart
import 'package:envied/envied.dart';
// import 'package:xidian_weather/util/const.dart';

part 'envied.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'APIKEY', obfuscate: true)
  static final String apiKey = _Env.apiKey;
}