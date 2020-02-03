import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class ArrivalViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStations;
  List<StationStatus> _listStationsWithBikes;
  List<StationStatus> _filteredStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStations => _listStations;

  List<StationStatus> get listStationsWithBikes => _listStationsWithBikes;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  List<StationStatus> get filteredStations => _filteredStations;

  void getClosestStationsWithDocks() async {
    Position currentPosition = await _geolocService.localizeUser();
    _listStations = await _api.fetchStations(
        currentPosition.latitude, currentPosition.longitude);
    _listStationsWithBikes = _listStations
        .where((station) => station.lastState.num_docks_available > 0)
        .toList();
    notifyListeners();
  }

  double getAvailability(int index) {
    return _listStations[index].lastState.num_docks_available /
        _listStations[index].capacity;
  }

  Color getAvailabilityColor(int index) {
    var availability = getAvailability(index);
    if (availability < 0.2) {
      return Colors.red;
    }
    if (availability > 0.5) {
      return Colors.lightGreenAccent;
    }
    return Colors.orangeAccent;
  }
}
