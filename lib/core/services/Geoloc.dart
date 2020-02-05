import 'package:geolocator/geolocator.dart';

class Geoloc {
  Future<Position> localizeUser() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<double> distanceBetween(
      latitude_a, longitude_a, latitude_b, longitude_b) async {
    return await Geolocator()
        .distanceBetween(latitude_a, longitude_a, latitude_b, longitude_b);
  }
}
