import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/services/Api.dart';

class SearchViewModel extends ChangeNotifier {
  Api _api = Api();
  List<Station> _listStations;
  List<Placemark> _placemark;
  TextEditingController _editingController = TextEditingController();

  List<Station> get listStations => _listStations;

  TextEditingController get editingController => _editingController;

  List<Placemark> get placemark => _placemark;

  void fetchStations() async {
    _listStations = await _api.fetchStations();
    notifyListeners();
  }

  void filterItems(String value) async {
    try {
      _placemark = await Geolocator()
          .placemarkFromAddress(value, localeIdentifier: "fr_FR");
      print(_placemark.map((p) => p.name));
    } catch (e) {
      _placemark = List<Placemark>();
    } finally {
      notifyListeners();
    }
//    _filteredStations = _listStations
//        .where((station) =>
//            station.name.toLowerCase().contains(value.toLowerCase()))
//        .toList();
  }
}
