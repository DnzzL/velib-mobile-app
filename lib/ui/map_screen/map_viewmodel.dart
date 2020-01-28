import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';
import 'package:velibetter/ui/search_screen/search_screen.dart';
import 'package:velibetter/ui/take_screen/take_screen.dart';

class MapViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  LatLng _userPosition;
  List<Station> _listStations;
  List<Marker> _listStationsMarkers;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  MapController mapController = MapController();

  LatLng get userPosition => _userPosition;

  List<Station> get listStations => _listStations;

  List<Marker> get listStationsMarkers => _listStationsMarkers;

  void fetchStations() async {
    Position currentPosition = await _geolocService.localizeUser();
    _listStations = await _api.fetchStations(
        currentPosition.latitude, currentPosition.longitude);
    _listStationsMarkers = _listStations.map((station) {
      return Marker(
        width: 10.0,
        height: 10.0,
        point: LatLng(station.lat, station.lon),
        builder: (ctx) => new Container(
            child: Opacity(
          opacity: 0.8,
          child: Icon(
            Icons.location_on,
            size: 20,
            color: Colors.redAccent,
          ),
        )),
      );
    }).toList();
    notifyListeners();
  }

  void localizeUserLive() async {
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        _userPosition = LatLng(position.latitude, position.longitude);
        mapController.move(_userPosition, 14.0);
        notifyListeners();
      }
    });
  }

  void toSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
    notifyListeners();
  }

  void toTakePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakeScreen()),
    );
    notifyListeners();
  }
}
