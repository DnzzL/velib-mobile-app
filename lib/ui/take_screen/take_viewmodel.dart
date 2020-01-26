import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class TakeViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<Station> _listStations;
  List<StationStatus> _listStationsStatus;
  List<Station> _filteredStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<Station> get listStations => _listStations;

  List<StationStatus> get listStationsStatus => _listStationsStatus;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  List<Station> get filteredStations => _filteredStations;

  void fetchClosestStations() async {
    Position currentPosition = await _geolocService.localizeUser();
    _listStations = await _api.fetchClosestStations(
        currentPosition.latitude, currentPosition.longitude);
    _listStationsStatus = await Future.wait(_listStations
        .getRange(0, 10)
        .map((station) => _api.fetchNumberBikesAtStation(station.station_id))
        .toList());
    notifyListeners();
  }

  double getAvailability(int index, String type) {
    return type == "mechanical"
        ? _listStationsStatus[index].mechanical / _listStations[index].capacity
        : _listStationsStatus[index].ebike / _listStations[index].capacity;
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
