import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class TakeViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<Station> _listStations;
  List<Station> _listStationsWithBikes;
  List<Station> _filteredStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<Station> get listStations => _listStations;
  List<Station> get listStationsWithBikes => _listStationsWithBikes;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  List<Station> get filteredStations => _filteredStations;

  void getClosestStationsWithBikes() async {
    Position currentPosition = await _geolocService.localizeUser();
    _listStations = await _api.fetchStations(
        currentPosition.latitude, currentPosition.longitude);
    _listStationsWithBikes = _listStations.where((station) =>
        station.lastState.mechanical > 0 || station.lastState.ebike > 0);
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
