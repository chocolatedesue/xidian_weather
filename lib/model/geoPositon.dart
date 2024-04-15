class GeoPosiition {
  // 只保留两位小数
  final String latitude;
  final String longitude;

  GeoPosiition({required this.latitude, required this.longitude});

  // GeoPosition

  factory GeoPosiition.fromJson(Map<String, dynamic> json) {
    //  11.11111 -> 11.11
    // var lat = double.parse(json['lat']).toStringAsFixed(2);
    // var lon = double.parse(json['lon']).toStringAsFixed(2);

    // return GeoPosition(latitude: lat, longitude: lon);
    return GeoPosiition(latitude: json['lat'], longitude: json['lon']);
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
