// To parse this JSON data, do
//
//     final airInfo = airInfoFromJson(jsonString);

import 'dart:convert';

AirInfo airInfoFromJson(String str) => AirInfo.fromJson(json.decode(str));

String airInfoToJson(AirInfo data) => json.encode(data.toJson());

class AirInfo {
    String code;
    String updateTime;
    String fxLink;
    Now now;
    // List<Now> station;
    Refer refer;

    AirInfo({
        required this.code,
        required this.updateTime,
        required this.fxLink,
        required this.now,
        // required this.station,
        required this.refer,
    });

    factory AirInfo.fromJson(Map<String, dynamic> json) => AirInfo(
        code: json["code"],
        updateTime: json["updateTime"],
        fxLink: json["fxLink"],
        now: Now.fromJson(json["now"]),
        // station: List<Now>.from(json["station"].map((x) => Now.fromJson(x))),
        refer: Refer.fromJson(json["refer"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "updateTime": updateTime,
        "fxLink": fxLink,
        "now": now.toJson(),
        // "station": List<dynamic>.from(station.map((x) => x.toJson())),
        "refer": refer.toJson(),
    };
}

class Now {
    String pubTime;
    String aqi;
    String level;
    String category;
    String primary;
    String pm10;
    String pm2P5;
    String no2;
    String so2;
    String co;
    String o3;
    String? name;
    String? id;

    Now({
        required this.pubTime,
        required this.aqi,
        required this.level,
        required this.category,
        required this.primary,
        required this.pm10,
        required this.pm2P5,
        required this.no2,
        required this.so2,
        required this.co,
        required this.o3,
        this.name,
        this.id,
    });

    factory Now.fromJson(Map<String, dynamic> json) => Now(
        pubTime: json["pubTime"],
        aqi: json["aqi"],
        level: json["level"],
        category: json["category"],
        primary: json["primary"],
        pm10: json["pm10"],
        pm2P5: json["pm2p5"],
        no2: json["no2"],
        so2: json["so2"],
        co: json["co"],
        o3: json["o3"],
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "pubTime": pubTime,
        "aqi": aqi,
        "level": level,
        "category": category,
        "primary": primary,
        "pm10": pm10,
        "pm2p5": pm2P5,
        "no2": no2,
        "so2": so2,
        "co": co,
        "o3": o3,
        "name": name,
        "id": id,
    };
}

class Refer {
    List<String>? sources;
    List<String>? license;

    Refer({
         this.sources,
         this.license,
    });

    factory Refer.fromJson(Map<String, dynamic> json) => Refer(
      // source and license are optional
        sources: json["sources"] == null ? null : List<String>.from(json["sources"].map((x) => x)),
        license: json["license"] == null ? null : List<String>.from(json["license"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "sources": sources == null ? null : List<dynamic>.from(sources!.map((x) => x)),
        "license": license == null ? null : List<dynamic>.from(license!.map((x) => x)),
    };
}
