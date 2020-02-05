import 'package:flutter/foundation.dart' as navigation_viewmodel;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';
import 'package:velibetter/core/services/RouteService.dart';
import 'package:velibetter/ui/arrival_screen/arrival_screen.dart';
import 'package:velibetter/ui/departure_screen/departure_screen.dart';

class MapViewModel extends navigation_viewmodel.ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  LatLng _userPosition;
  List<StationInfo> _listStationInfo;
  List<Marker> _listStationsMarkers;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  MapController mapController = MapController();

  LatLng get userPosition => _userPosition;

  List<StationInfo> get listStations => _listStationInfo;

  List<Marker> get listStationsMarkers => _listStationsMarkers;

  void fetchStations() async {
    _listStationInfo = await _api.fetchInfo();
    _listStationsMarkers = _listStationInfo.map((station) {
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

  void localizeUser() async {
    Position currentPosition = await _geolocService.localizeUser();
    _userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
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
      MaterialPageRoute(builder: (context) => DepartureScreen()),
    );
    notifyListeners();
  }

  void toDeparturePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepartureScreen()),
    );
    notifyListeners();
  }

  void toArrivalPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArrivalScreen()),
    );
    notifyListeners();
  }
}
