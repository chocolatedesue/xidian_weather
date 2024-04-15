class GeoInfo {
  String id;
  String cityName;
  GeoInfo({required this.id, required this.cityName});

  factory GeoInfo.fromJson(Map<String, dynamic> json) {
    return GeoInfo(id: json['id'], cityName: json['name']);
  }

  @override
  String toString() {
    return 'GeoInfo{id: $id, CityName: $cityName}';
  }
}
