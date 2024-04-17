// To parse this JSON data, do
//
//     final the7DayWeather = the7DayWeatherFromJson(jsonString);



class The7DayWeather {
    String code;
    String updateTime;
    String fxLink;
    List<Daily> daily;
    Refer refer;

    The7DayWeather({
        required this.code,
        required this.updateTime,
        required this.fxLink,
        required this.daily,
        required this.refer,
    });

    factory The7DayWeather.fromJson(Map<String, dynamic> json) => The7DayWeather(
        code: json["code"],
        updateTime: json["updateTime"],
        fxLink: json["fxLink"],
        daily: List<Daily>.from(json["daily"].map((x) => Daily.fromJson(x))),
        refer: Refer.fromJson(json["refer"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "updateTime": updateTime,
        "fxLink": fxLink,
        "daily": List<dynamic>.from(daily.map((x) => x.toJson())),
        "refer": refer.toJson(),
    };
}

class Daily {
    DateTime fxDate;
    String sunrise;
    String sunset;
    String moonrise;
    String moonset;
    String moonPhase;
    String moonPhaseIcon;
    String tempMax;
    String tempMin;
    String iconDay;
    String textDay;
    String iconNight;
    String textNight;
    String wind360Day;
    String windDirDay;
    String windScaleDay;
    String windSpeedDay;
    String wind360Night;
    String windDirNight;
    String windScaleNight;
    String windSpeedNight;
    String humidity;
    String precip;
    String pressure;
    String vis;
    String cloud;
    String uvIndex;

    Daily({
        required this.fxDate,
        required this.sunrise,
        required this.sunset,
        required this.moonrise,
        required this.moonset,
        required this.moonPhase,
        required this.moonPhaseIcon,
        required this.tempMax,
        required this.tempMin,
        required this.iconDay,
        required this.textDay,
        required this.iconNight,
        required this.textNight,
        required this.wind360Day,
        required this.windDirDay,
        required this.windScaleDay,
        required this.windSpeedDay,
        required this.wind360Night,
        required this.windDirNight,
        required this.windScaleNight,
        required this.windSpeedNight,
        required this.humidity,
        required this.precip,
        required this.pressure,
        required this.vis,
        required this.cloud,
        required this.uvIndex,
    });

    factory Daily.fromJson(Map<String, dynamic> json) => Daily(
        fxDate: DateTime.parse(json["fxDate"]),
        sunrise: json["sunrise"],
        sunset: json["sunset"],
        moonrise: json["moonrise"],
        moonset: json["moonset"],
        moonPhase: json["moonPhase"],
        moonPhaseIcon: json["moonPhaseIcon"],
        tempMax: json["tempMax"],
        tempMin: json["tempMin"],
        iconDay: json["iconDay"],
        textDay: json["textDay"],
        iconNight: json["iconNight"],
        textNight: json["textNight"],
        wind360Day: json["wind360Day"],
        windDirDay: json["windDirDay"],
        windScaleDay: json["windScaleDay"],
        windSpeedDay: json["windSpeedDay"],
        wind360Night: json["wind360Night"],
        windDirNight: json["windDirNight"],
        windScaleNight: json["windScaleNight"],
        windSpeedNight: json["windSpeedNight"],
        humidity: json["humidity"],
        precip: json["precip"],
        pressure: json["pressure"],
        vis: json["vis"],
        cloud: json["cloud"],
        uvIndex: json["uvIndex"],
    );

    Map<String, dynamic> toJson() => {
        "fxDate": "${fxDate.year.toString().padLeft(4, '0')}-${fxDate.month.toString().padLeft(2, '0')}-${fxDate.day.toString().padLeft(2, '0')}",
        "sunrise": sunrise,
        "sunset": sunset,
        "moonrise": moonrise,
        "moonset": moonset,
        "moonPhase": moonPhase,
        "moonPhaseIcon": moonPhaseIcon,
        "tempMax": tempMax,
        "tempMin": tempMin,
        "iconDay": iconDay,
        "textDay": textDay,
        "iconNight": iconNight,
        "textNight": textNight,
        "wind360Day": wind360Day,
        "windDirDay": windDirDay,
        "windScaleDay": windScaleDay,
        "windSpeedDay": windSpeedDay,
        "wind360Night": wind360Night,
        "windDirNight": windDirNight,
        "windScaleNight": windScaleNight,
        "windSpeedNight": windSpeedNight,
        "humidity": humidity,
        "precip": precip,
        "pressure": pressure,
        "vis": vis,
        "cloud": cloud,
        "uvIndex": uvIndex,
    };
}

class Refer {
    List<String> sources;
    List<String> license;

    Refer({
        required this.sources,
        required this.license,
    });

    factory Refer.fromJson(Map<String, dynamic> json) => Refer(
        sources: List<String>.from(json["sources"].map((x) => x)),
        license: List<String>.from(json["license"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "sources": List<dynamic>.from(sources.map((x) => x)),
        "license": List<dynamic>.from(license.map((x) => x)),
    };
}
