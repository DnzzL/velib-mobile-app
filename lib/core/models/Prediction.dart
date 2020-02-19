class Prediction {
  num stationId, deltaHours, forecast;
  String bikeType;

  Prediction(this.stationId, this.bikeType, this.deltaHours, this.forecast);

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(json['station_id'], json['bike_type'],
        json['delta_hours'], json['forecast']);
  }
}
