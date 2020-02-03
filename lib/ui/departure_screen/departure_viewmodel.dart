import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class DepartureViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStationStatus;
  List<StationInfo> _listStationInfo;
  List<StationStatus> _listStationsWithBikes;
  List<StationStatus> _filteredStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStations => _listStationStatus;

  List<StationStatus> get listStationsWithBikes => _listStationsWithBikes;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  List<StationStatus> get filteredStations => _filteredStations;

  void getClosestStationsWithBikes() async {
    _listStationStatus = await _api.fetchStatus();
    _listStationsWithBikes = _listStationStatus
        .where((station) => station.numBikesAvailable > 0)
        .toList();
    notifyListeners();
  }

  double getAvailability(int index, String type) {
    return type == "mechanical"
        ? _listStationStatus[index].numBikesAvailableTypes.mechanical /
            _listStationStatus[index].numDocksAvailable
        : _listStationStatus[index].numBikesAvailableTypes.ebike /
            _listStationStatus[index].numDocksAvailable;
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
}
