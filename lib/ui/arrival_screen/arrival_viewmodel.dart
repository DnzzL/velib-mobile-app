import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Geoloc.dart';
import 'package:velibetter/ui/navigation_screen/navigation_screen.dart';

class ArrivalViewModel extends ChangeNotifier {
  final List<StationInfo> listStationInfo;
  final List<StationStatus> listStationStatus;

  ArrivalViewModel(
      {@required this.listStationInfo, @required this.listStationStatus});

  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStationsWithDocks;
  List<String> _listStationNameSortedByDistance;
  LatLng _userPosition;
  TextEditingController _editingController = TextEditingController();
  List<int> _distances;

  List<StationStatus> get listStationsWithDocks => _listStationsWithDocks;

  List<String> get listStationNameSortedByDistance =>
      _listStationNameSortedByDistance;

  TextEditingController get editingController => _editingController;

  List<int> get distances => _distances;

  Future<Map<int, int>> getStationDistances() async {
    var sortable = <int, int>{};
    Position currentPosition = await _geolocService.localizeUser();
    _userPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    for (var stationInfo in listStationInfo) {
      var distance = await _geolocService.distanceBetween(
          _userPosition.latitude,
          _userPosition.longitude,
          stationInfo.lat,
          stationInfo.lon);
      sortable[stationInfo.stationId] = distance.ceil();
    }
    return sortable;
  }

  void getClosestStationsWithDocks() async {
    _listStationsWithDocks = listStationStatus
        .where((station) => station.numDocksAvailable > 0)
        .toList();
    var stationDistances = await getStationDistances();
    _distances = stationDistances.values.toList();
    _distances.sort();
    _listStationsWithDocks.sort((a, b) =>
        stationDistances[a.stationId] - stationDistances[b.stationId]);
    _listStationNameSortedByDistance =
        _listStationsWithDocks.map((stationStatus) {
      var stationInfo = listStationInfo
          .where(
              (stationInfo) => stationInfo.stationId == stationStatus.stationId)
          .toList()[0];
      return stationInfo.name;
    }).toList();
    notifyListeners();
  }

  double getAvailability(int index) {
    var stationInfo = listStationInfo
        .where((stationInfo) =>
            stationInfo.stationId == _listStationsWithDocks[index].stationId)
        .toList()[0];
    return _listStationsWithDocks[index].numDocksAvailable /
        stationInfo.capacity;
  }

  Color getAvailabilityColor(int index) {
    var availability = getAvailability(index);
    if (availability < 0.2) {
      return Color(0xFFF44336);
    }
    if (availability > 0.5) {
      return Color(0xFF4CAF50);
    }
    return Color(0xFFFF9800);
  }

  void toNavigationPage(BuildContext context, num stationId) {
    final stationInfo =
        listStationInfo.where((s) => s.stationId == stationId).toList().first;
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
