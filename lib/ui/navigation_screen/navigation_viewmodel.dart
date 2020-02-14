import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart' as navigation_viewmodel;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/NavigationStep.dart';
import 'package:velibetter/core/services/RouteService.dart';

class NavigationViewModel extends navigation_viewmodel.ChangeNotifier {
  RouteService _routeService = RouteService();
  LatLng departure;
  LatLng arrival;
  LatLng _userPosition;
  GeoJsonFeatureCollection _route;
  Map<String, double> _summary;
  List<NavigationStep> _steps;
  List<LatLng> _points;
  MapController mapController = MapController();

  NavigationViewModel({@required this.departure, @required this.arrival});

  LatLng get userPosition => _userPosition;

  List<NavigationStep> get steps => _steps;

  Map<String, double> get summary => _summary;

  List<LatLng> get points => _points;

  void getSteps() async {
    _route = await _routeService.fetchOpenRoute(departure.latitude,
        departure.longitude, arrival.latitude, arrival.longitude);
    _steps = _routeService.getSteps(_route);
    notifyListeners();
  }

  void getTrace() async {
    _route = await _routeService.fetchOpenRoute(departure.latitude,
        departure.longitude, arrival.latitude, arrival.longitude);
    var geometry = _routeService.getTrace(_route);
    _points = geometry.geoSerie.geoPoints
        .map((geopoint) => LatLng(geopoint.latitude, geopoint.longitude))
        .toList();
    notifyListeners();
  }

  void getSummary() async {
    _route = await _routeService.fetchOpenRoute(departure.latitude,
        departure.longitude, arrival.latitude, arrival.longitude);
    _summary = _routeService.getSummary(_route);
    notifyListeners();
  }

  void localizeUserLive() async {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) {
        _userPosition = LatLng(position.latitude, position.longitude);
        mapController.move(_userPosition, 14.0);
        notifyListeners();
      }
    });
  }

  IconData getNavigationIcon(int type) {
    switch (type) {
      case 0:
        return CommunityMaterialIcons.arrow_left_bold;
      case 1:
        return CommunityMaterialIcons.arrow_right_bold;
      case 2:
        return CommunityMaterialIcons.arrow_bottom_left_bold_outline;
      case 5:
        return CommunityMaterialIcons.arrow_right;
      case 10:
        return CommunityMaterialIcons.flag_checkered;
      case 11:
        return CommunityMaterialIcons.compass;
      default:
        return CommunityMaterialIcons.navigation;
    }
  }
}
