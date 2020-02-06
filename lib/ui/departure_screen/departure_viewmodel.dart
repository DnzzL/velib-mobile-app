import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';
import 'package:velibetter/ui/navigation_screen/navigation_screen.dart';

class DepartureViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStationStatus;
  List<StationInfo> _listStationInfo;
  List<StationStatus> _listStationsWithBikes;
  List<String> _listStationNameSortedByDistance;
  List<StationStatus> _filteredStations;
  LatLng _userPosition;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStationStatus => _listStationStatus;

  List<StationInfo> get listStationInfo => _listStationInfo;

  List<StationStatus> get listStationsWithBikes => _listStationsWithBikes;

  List<String> get listStationNameSortedByDistance =>
      _listStationNameSortedByDistance;

  TextEditingController get editingController => _editingController;

  List<StationStatus> get filteredStations => _filteredStations;

  Future<Map<int, int>> getStationDistances() async {
    var sortable = <int, int>{};
    Position currentPosition = await _geolocService.localizeUser();
    _userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    for (var stationInfo in _listStationInfo) {
      var distance = await _geolocService.distanceBetween(
          _userPosition.latitude,
          _userPosition.longitude,
          stationInfo.lat,
          stationInfo.lon);
      sortable[stationInfo.stationId] = distance.ceil();
    }
    return sortable;
  }

  void getClosestStationsWithBikes() async {
    _listStationStatus = await _api.fetchStatus();
    _listStationInfo = await _api.fetchInfo();
    _listStationsWithBikes = _listStationStatus
        .where((stationStatus) => stationStatus.numBikesAvailable > 0)
        .toList();
    var distances = await getStationDistances();
    _listStationsWithBikes
        .sort((a, b) => distances[a.stationId] - distances[b.stationId]);
    _listStationNameSortedByDistance =
        _listStationsWithBikes.map((stationStatus) {
      var stationInfo = _listStationInfo
          .where(
              (stationInfo) => stationInfo.stationId == stationStatus.stationId)
          .toList()[0];
      return stationInfo.name;
    }).toList();
    notifyListeners();
  }

  double getAvailability(int index, String type) {
    return type == "mechanical"
        ? _listStationStatus[index].numBikesAvailableTypes.mechanical /
            _listStationInfo[index].capacity
        : _listStationStatus[index].numBikesAvailableTypes.ebike /
            _listStationInfo[index].capacity;
  }

  Color getAvailabilityColor(int index, String type) {
    var availability = getAvailability(index, type);
    if (availability < 0.2) {
      return Colors.red;
    }
    if (availability > 0.5) {
      return Colors.lightGreenAccent;
    }
    return Colors.orangeAccent;
  }

  void toNavigationPage(BuildContext context, num stationId) {
    final stationInfo =
        _listStationInfo.where((s) => s.stationId == stationId).toList().first;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NavigationScreen(
                departure: _userPosition,
                arrival: LatLng(stationInfo.lat, stationInfo.lon),
              )),
    );
    notifyListeners();
  }
}
