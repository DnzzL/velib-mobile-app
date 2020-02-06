import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';

class DetailViewModel extends ChangeNotifier {
  LatLng _userPosition;
  StationInfo stationInfo;
  StationStatus stationStatus;

  DetailViewModel({@required this.stationInfo, @required this.stationStatus});

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  LatLng get userPosition => _userPosition;
}
