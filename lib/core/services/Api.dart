import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Api {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  List<StationStatus> listStationStatus;
  List<StationInfo> listStationInfo;

  Future<List<StationStatus>> fetchStatus() async {
    var url =
        'https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_status.json';
    try {
      var file = await cacheManager.getSingleFile(url);
      var response = file.readAsStringSync();
      listStationStatus = new List<StationStatus>.from(jsonDecode(response)
          .map((e) => StationStatus.fromJson(e["data"]["stations"]))
          .toList());
      return listStationStatus;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<StationInfo>> fetchInfo() async {
    var url =
        'https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_information.json';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      listStationInfo = new List<StationInfo>.from(
          jsonDecode(utf8.decode(response.bodyBytes))
              .map((e) => StationInfo.fromJson(e["data"]["stations"]))
              .toList());
      return listStationInfo;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to fetch Velib API');
    }
  }
}

void main() {
  var _api = Api();
  print(_api.fetchInfo());
  print(_api.fetchStatus());
}
