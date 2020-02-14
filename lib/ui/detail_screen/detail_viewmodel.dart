import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/ui/navigation_screen/navigation_screen.dart';

class DetailViewModel extends ChangeNotifier {
  LatLng userPosition;
  int stationIndex;
  List<StationInfo> listStationInfo;
  List<StationStatus> listStationStatus;

  DetailViewModel(
      {@required this.stationIndex,
      @required this.userPosition,
      @required this.listStationInfo,
      @required this.listStationStatus});

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  void toNavigationPage(BuildContext context, StationInfo stationInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NavigationScreen(
                departure: userPosition,
                arrival: LatLng(stationInfo.lat, stationInfo.lon),
              )),
    );
    notifyListeners();
  }
}
