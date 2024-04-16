class GeoPosiition {
  // 只保留两位小数
  final String lat;
  final String lon;

  GeoPosiition({required this.lat, required this.lon});

  // GeoPosition

  factory GeoPosiition.fromJson(Map<String, dynamic> json) {
    //  11.11111 -> 11.11
    // var lat = double.parse(json['lat']).toStringAsFixed(2);
    // var lon = double.parse(json['lon']).toStringAsFixed(2);

    // return GeoPosition(latitude: lat, longitude: lon);
    return GeoPosiition(lat: json['lat'], lon: json['lon']);
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': lat,
      'longitude': lon,
    };
  }
}
