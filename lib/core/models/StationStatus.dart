class StationStatus {
  int stationCode,
      station_id,
      num_bikes_available,
      numBikesAvailable,
      num_docks_available,
      numDocksAvailable,
      is_installed,
      is_returning,
      is_renting,
      last_reported,
      mechanical,
      ebike;

  StationStatus(
      this.stationCode,
      this.station_id,
      this.num_bikes_available,
      this.numBikesAvailable,
      this.num_docks_available,
      this.numDocksAvailable,
      this.is_installed,
      this.is_returning,
      this.is_renting,
      this.last_reported,
      this.mechanical,
      this.ebike);
}
