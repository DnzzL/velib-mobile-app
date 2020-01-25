import 'dart:convert';

import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:http/http.dart' as http;

class Api {
  var root = "http://10.0.2.2:8000";

//  void fetchNumberBikesAtStation(int stationId) async {
//    var url = '$root/state/$stationId';
//    var response = await http.get(url);
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');
//    var body = response.body as Map<String, int>;
//    StationStatus(...body);
//  }

  Future<List<Station>> fetchStations() async {
    var url = '$root/stations';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<Station> stations = new List<Station>.from(
          jsonDecode(utf8.decode(response.bodyBytes))
              .map((e) => Station.fromJson(e))
              .toList());
      return stations;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
