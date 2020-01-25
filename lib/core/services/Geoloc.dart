import 'package:geolocator/geolocator.dart';

class Geoloc {
  Future<Position> localizeUser() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
