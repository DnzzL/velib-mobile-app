import 'package:velibetter/core/models/StationStatus.dart';

class Station {
  num stationId, lat, lon, capacity, indexDeparture, indexArrival, distance = 0;
  String name, stationCode;
  List<String> rental_methods = List<String>();
  StationStatus lastState;

  Station(
      this.stationId,
      this.lat,
      this.lon,
      this.capacity,
      this.name,
      this.stationCode,
      this.rental_methods,
      this.distance,
      this.lastState,
      this.indexDeparture,
      this.indexArrival);

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
        json['station_id'],
        json['lat'],
        json['lon'],
        json['capacity'],
        json['name'],
        json['stationCode'],
        List<String>(),
        json['distance'],
        StationStatus.fromJson(json['last_state']),
        json['index_departure'],
        json['index_arrival']);
  }
}
