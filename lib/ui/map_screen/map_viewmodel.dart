import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';
import 'package:velibetter/ui/arrival_screen/arrival_screen.dart';
import 'package:velibetter/ui/departure_screen/departure_screen.dart';
import 'package:velibetter/ui/detail_screen/detail_screen.dart';

class MapViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  LatLng _userPosition;
  List<StationInfo> listStationInfo;
  List<StationStatus> listStationStatus;
  List<Marker> _listStationsMarkers;

  MapController mapController = MapController();

  LatLng get userPosition => _userPosition;

  List<Marker> get listStationsMarkers => _listStationsMarkers;

  void getStationMarkers(BuildContext context) async {
    listStationInfo = await _api.fetchInfo();
    listStationStatus = await _api.fetchStatus();
    _listStationsMarkers = listStationInfo.map((stationInfo) {
      var stationIndex = listStationInfo.indexOf(stationInfo);
      return Marker(
        width: 30.0,
        height: 30.0,
        point: LatLng(stationInfo.lat, stationInfo.lon),
        builder: (ctx) => Container(
            child: GestureDetector(
                onTap: () => toDetailPage(
                    context, stationIndex, listStationInfo, listStationStatus),
                child: new Container(
                    child: Opacity(
                  opacity: 0.8,
                  child: Icon(
                    Icons.location_on,
                    size: 20,
                    color: Color(0xFFF44336),
                  ),
                )))),
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
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        _userPosition = LatLng(position.latitude, position.longitude);
        mapController.move(_userPosition, 14.0);
        notifyListeners();
      }
    });
  }

  void toDeparturePage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DepartureScreen(
                listStationInfo: listStationInfo,
                listStationStatus: listStationStatus,
              )),
    );
    notifyListeners();
  }

  void toArrivalPage(BuildContext context, List<StationInfo> listStationInfo,
      List<StationStatus> listStationStatus) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArrivalScreen(
                listStationInfo: listStationInfo,
                listStationStatus: listStationStatus,
              )),
    );
    notifyListeners();
  }

  void toDetailPage(
      BuildContext context,
      int stationIndex,
      List<StationInfo> listStationInfo,
      List<StationStatus> listStationStatus) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailScreen(
                stationIndex: stationIndex,
                userPosition: userPosition,
                listStationInfo: listStationInfo,
                listStationStatus: listStationStatus,
              )),
    );
    notifyListeners();
  }
}
