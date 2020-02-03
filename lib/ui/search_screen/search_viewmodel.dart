import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/core/services/Api.dart';
import 'package:velibetter/core/services/Geoloc.dart';

class SearchViewModel extends ChangeNotifier {
  Api _api = Api();
  Geoloc _geolocService = Geoloc();
  List<StationStatus> _listStations;
  List<StationStatus> _filteredStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<StationStatus> get listStations => _listStations;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  List<StationStatus> get filteredStations => _filteredStations;

  void fetchClosestStations() async {
    Position currentPosition = await _geolocService.localizeUser();
    _api.fetchStations(currentPosition.latitude, currentPosition.longitude);
    _listStations = _api.listStationStatus;
    notifyListeners();
  }

  void filterItems(String value) async {
//    try {
//      _placemark = await Geolocator()
//          .placemarkFromAddress(value, localeIdentifier: "fr_FR");
//      print(_placemark.map((p) => p.name));
//    } catch (e) {
//      _placemark = List<Placemark>();
//    } finally {
//      notifyListeners();
//    }

    _filteredStations = _listStations
        .where((station) =>
            station.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
