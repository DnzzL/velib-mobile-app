import 'package:flutter/foundation.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/services/Api.dart';

class SearchViewModel extends ChangeNotifier {
  Api _api = Api();
  List<Station> _listStations;

  List<Station> get listStations => _listStations;

  void fetchStations() async {
    _listStations = await _api.fetchStations();
    notifyListeners();
  }
}
