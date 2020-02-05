import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class ArrivalViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStationStatus;
  List<StationStatus> _listStationsWithBikes;
  List<StationInfo> _listStationInfo;
  List<StationStatus> _filteredStations;
  List<String> _listStationNameSortedByDistance;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStations => _listStationStatus;

  List<StationStatus> get listStationsWithBikes => _listStationsWithBikes;

  List<String> get listStationNameSortedByDistance =>
      _listStationNameSortedByDistance;

  TextEditingController get editingController => _editingController;

  List<StationInfo> get listStationInfo => _listStationInfo;

  List<StationStatus> get filteredStations => _filteredStations;

  Future<Map<int, int>> getStationDistances() async {
    var sortable = <int, int>{};
    Position currentPosition = await _geolocService.localizeUser();
    var userPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    for (var stationInfo in _listStationInfo) {
      var distance = await _geolocService.distanceBetween(userPosition.latitude,
          userPosition.longitude, stationInfo.lat, stationInfo.lon);
      sortable[stationInfo.stationId] = distance.ceil();
    }
    return sortable;
  }

  void getClosestStationsWithDocks() async {
    _listStationStatus = await _api.fetchStatus();
    _listStationInfo = await _api.fetchInfo();
    _listStationsWithBikes = _listStationStatus
        .where((station) => station.numDocksAvailable > 0)
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

  num getAvailability(int index) {
    return _listStationStatus[index].numDocksAvailable;
  }

  Color getAvailabilityColor(int index) {
    var availability = getAvailability(index);
    if (availability < 5) {
      return Colors.red;
    }
    if (availability > 10) {
      return Colors.lightGreenAccent;
    }
    return Colors.orangeAccent;
  }
}
