import 'dart:convert';

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
      listStationStatus = new List<StationStatus>.from(
          jsonDecode(response)['data']['stations']
              .map((e) => StationStatus.fromJson(e))
              .toList());
      return listStationStatus;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<List<StationInfo>> fetchInfo() async {
    var url =
        'https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_information.json';
    try {
      var file = await cacheManager.getSingleFile(url);
      var response = file.readAsStringSync();
      listStationInfo = new List<StationInfo>.from(jsonDecode(response)['data']
              ['stations']
          .map((e) => StationInfo.fromJson(e))
          .toList());
      return listStationInfo;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
