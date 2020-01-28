import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velibetter/core/models/Station.dart';

class Api {
  var root = "http://10.0.2.2:8000";
  List<Station> listStations;

  Future<List<Station>> fetchStations(num latitude, num longitude) async {
    if (listStations == null) {
      var url = '$root/stations/?latitude=$latitude&longitude=$longitude';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        listStations = new List<Station>.from(
            jsonDecode(utf8.decode(response.bodyBytes))
                .map((e) => Station.fromJson(e))
                .toList());
        return listStations;
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    } else {
      return listStations;
    }
  }
}
