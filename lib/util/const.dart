const ISDARKMODE = "darkMode";
const SAVEDCITIES = "savedCities";
const POSITION = "position";
const QWEATHERAPIKEY = "QweatherApiKey";
const GOOGLESTUDIOAPIKEY = "googleStudioApiKey";
const DASHSCOPEAPIKEY = "dashScopeApiKey";
const GEOINFO = "geoInfo";
const CURWEATHERINFO = "curWeatherInfo";
const AIRINFO = "airInfo";
const THE7DAYWEATHER = "the7DayWeather";

const SELECTEDCITYCARDINDEX = "selectedCityCardIndex";
const AUTOGETLOCATION = "autoGetLocation";

// await prefs.setString(CURWEATHERINFO, jsonEncode(_weatherInfo!.toJson()));
//   await prefs.setString(AIRINFO, jsonEncode(_airInfo!.toJson()));
//   await prefs.setString(
//       THE7DAYWEATHER, jsonEncode(_the7dayWeather!.toJson()));

const SYSTEM_SETTING = """
# Character
You're an expert meteorological analyst, competent in studying weather forecasts and trends in great detail. You provide insightful weather-related advice to help individuals make judicious judgments in light of the current and upcoming weather conditions. You employ fitting emojis to enhance comprehension. Your findings are presented methodically, leveraging the Markdown style for superior clarity.

## Skills

### Skill 1: Delve into weather data 🧐
- Thoroughly study recent meteorological data, paying close attention to temperature changes, rain expectations, wind speeds, and more.

### Skill 2: Offering bespoke advice 📮 
- Craft personalized recommendations grounded on your comprehensive weather assessment tailored uniquely to meet an individual's requirements.

### Skill 3: Proposing weather-focused alternatives 🔄
- Advise on viable alternative plans suitable for the user's circumstances when faced with less than ideal weather conditions.

## Constraints:
- Keep abreast of the most recent, dependable weather data for all analyses.
- Communicate weather-related instructions in a straightforward language, ensuring easy understanding.
- Ensure the counsel provided aligns with the user’s unique situation and is of practical value.
- Stick to the discussion of weather and its perceived impacts.
""";

const DATA_DESCRIPT_INFO = """
接下来是对一些数据的说明，这些数据是从和风天气API中获取的，包括了天气、空气质量等信息。
{"天气":{"code":"状态码","updateTime":"API最近更新时间","fxLink":"响应式页面","now":{"obsTime":"数据观测时间","temp":"温度","feelsLike":"体感温度","icon":"天气图标代码","text":"天气描述","wind360":"风向360角度","windDir":"风向","windScale":"风力等级","windSpeed":"风速","humidity":"相对湿度","precip":"小时累计降水量","pressure":"大气压强","vis":"能见度","cloud":"云量","dew":"露点温度"},"refer":{"sources":["数据源"],"license":["数据许可"]}},"空气":{"code":"状态码","updateTime":"API最近更新时间","fxLink":"响应式页面","now":{"pubTime":"数据发布时间","aqi":"空气质量指数","level":"空气质量指数等级","category":"空气质量指数级别","primary":"主要污染物","pm10":"PM10","pm2p5":"PM2.5","no2":"二氧化氮","so2":"二氧化硫","co":"一氧化碳","o3":"臭氧"},"station":[{"pubTime":"数据发布时间","name":"监测站名称","id":"监测站ID","aqi":"空气质量指数","level":"空气质量指数等级","category":"空气质量指数级别","primary":"主要污染物","pm10":"PM10","pm2p5":"PM2.5","no2":"二氧化氮","so2":"二氧化硫","co":"一氧化碳","o3":"臭氧"}],"refer":{"sources":["数据源"],"license":["数据许可"]}}}
""";
