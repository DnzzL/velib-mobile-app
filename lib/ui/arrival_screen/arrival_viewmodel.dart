import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class ArrivalViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStationStatus;
  List<StationStatus> _listStationsWithBikes;
  List<StationStatus> _filteredStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStations => _listStationStatus;

  List<StationStatus> get listStationsWithBikes => _listStationsWithBikes;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  List<StationStatus> get filteredStations => _filteredStations;

  void getClosestStationsWithDocks() async {
    _listStationStatus = await _api.fetchStatus();
    _listStationsWithBikes = _listStationStatus
        .where((station) => station.numDocksAvailable > 0)
        .toList();
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
