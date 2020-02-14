import 'dart:convert';

import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';

class Api {
  List<StationStatus> listStationStatus;
  List<StationInfo> listStationInfo;

  Future<List<StationStatus>> fetchStatus() async {
    final store = await CacheStore.getInstance(
        policy: CacheControlPolicy(
      maxCount: 999,
      minAge: null,
      maxAge: Duration(minutes: 5),
    ));
    var url =
        'https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_status.json';
    try {
      var file = await store.getFile(url);
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
    final store = await CacheStore.getInstance(
        policy: CacheControlPolicy(
          maxCount: 999,
          minAge: null,
          maxAge: Duration(minutes: 5),
        ));
    var url =
        'https://velib-metropole-opendata.smoove.pro/opendata/Velib_Metropole/station_information.json';
    try {
      var file = await store.getFile(url);
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
