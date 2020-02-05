class StationInfo {
  num stationId, lat, lon, capacity;
  String name, stationCode;

  StationInfo(this.stationId, this.name, this.lat, this.lon, this.capacity,
      this.stationCode);

  factory StationInfo.fromJson(Map<String, dynamic> json) {
    return StationInfo(json['station_id'], json['name'], json['lat'],
        json['lon'], json['capacity'], json['station_code']);
  }
}
