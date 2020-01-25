class Station {
  num station_id, lat, lon, capacity;
  String name, stationCode;
  List<String> rental_methods = List<String>();

  Station(this.station_id, this.lat, this.lon, this.capacity, this.name,
      this.stationCode, this.rental_methods);

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(json['station_id'], json['lat'], json['lon'],
        json['capacity'], json['name'], json['stationCode'], List<String>());
  }
}
