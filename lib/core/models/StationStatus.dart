import 'package:velibetter/core/models/NumBikesAvailableTypes.dart';

class StationStatus {
  String stationCode;
  num stationId, numBikesAvailable, numDocksAvailable, lastReported;
  bool isInstalled, isReturning, isRenting;
  NumBikesAvailableTypes numBikesAvailableTypes;

  StationStatus(
      this.stationCode,
      this.stationId,
      this.numBikesAvailable,
      this.numBikesAvailableTypes,
      this.numDocksAvailable,
      this.isInstalled,
      this.isReturning,
      this.isRenting,
      this.lastReported);

  factory StationStatus.fromJson(Map<String, dynamic> json) {
    return StationStatus(
        json['stationCode'],
        json['station_id'],
        json['num_bikes_available'],
        NumBikesAvailableTypes.fromJson(json['num_bikes_available_types']),
        json['num_docks_available'],
        json['is_installed'],
        json['is_returning'],
        json['is_renting'],
        json['last_reported']);
  }
}
