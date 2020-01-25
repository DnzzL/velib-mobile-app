import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/services/Api.dart';

class SearchViewModel extends ChangeNotifier {
  Api _api = Api();
  List<Station> _listStations;
  List<Station> _filteredStations;
  TextEditingController _editingController = TextEditingController();

  List<Station> get listStations => _listStations;

  TextEditingController get editingController => _editingController;

  List<Station> get filteredStations => _filteredStations;

  void fetchStations() async {
    _listStations = await _api.fetchStations();
    notifyListeners();
  }

  void filterItems(String value) {
    _filteredStations = _listStations
        .where((station) =>
            station.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
