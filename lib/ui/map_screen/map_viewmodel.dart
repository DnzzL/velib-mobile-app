import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:velibetter/ui/map_screen/map_screen.dart';
import 'package:velibetter/ui/search_screen/search_screen.dart';

class MapViewModel extends ChangeNotifier {
  LatLng _userPosition;

  MapController mapController = MapController();

  LatLng get userPosition => _userPosition;

  void localizeUser() async {
    var location = new Location();
    location.onLocationChanged().listen((LocationData currentLocation) {
      _userPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController.move(_userPosition, 14.0);
      notifyListeners();
    });
  }

  void toSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
    notifyListeners();
  }
}
