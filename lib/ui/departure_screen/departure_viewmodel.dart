import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class DepartureViewModel extends ChangeNotifier {
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

  void getClosestStationsWithBikes() async {
    Position currentPosition = await _geolocService.localizeUser();
    _listStations = await _api.fetchStations(
        currentPosition.latitude, currentPosition.longitude);
    _listStationsWithBikes = _listStations
        .where((station) => station.lastState.num_bikes_available > 0)
        .toList();
    notifyListeners();
  }

  double getAvailability(int index, String type) {
    return type == "mechanical"
        ? _listStations[index].lastState.mechanical /
            _listStations[index].capacity
        : _listStations[index].lastState.ebike / _listStations[index].capacity;
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
