import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Geoloc.dart';
import 'package:velibetter/ui/navigation_screen/navigation_screen.dart';

class DepartureViewModel extends ChangeNotifier {
  List<StationInfo> listStationInfo;
  List<StationStatus> listStationStatus;

  DepartureViewModel(
      {@required this.listStationInfo, @required this.listStationStatus});

  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStationsWithBikes;
  List<String> _listStationNameSortedByDistance;
  LatLng _userPosition;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStationsWithBikes => _listStationsWithBikes;

  List<String> get listStationNameSortedByDistance =>
      _listStationNameSortedByDistance;

  TextEditingController get editingController => _editingController;

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

  void getClosestStationsWithBikes() async {
    _listStationsWithBikes = listStationStatus
        .where((stationStatus) => stationStatus.numBikesAvailable > 0)
        .toList();
    var distances = await getStationDistances();
    _listStationsWithBikes
        .sort((a, b) => distances[a.stationId] - distances[b.stationId]);
    _listStationNameSortedByDistance =
        _listStationsWithBikes.map((stationStatus) {
      var stationInfo = listStationInfo
          .where(
              (stationInfo) => stationInfo.stationId == stationStatus.stationId)
          .toList()[0];
      return stationInfo.name;
    }).toList();
    notifyListeners();
  }

  double getAvailability(int index, String type) {
    var stationInfo = listStationInfo
        .where((stationInfo) =>
            stationInfo.stationId == _listStationsWithBikes[index].stationId)
        .toList()[0];
    return type == "mechanical"
        ? _listStationsWithBikes[index].numBikesAvailableTypes.mechanical /
            stationInfo.capacity
        : _listStationsWithBikes[index].numBikesAvailableTypes.ebike /
            stationInfo.capacity;
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
