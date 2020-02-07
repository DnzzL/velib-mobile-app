import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart' as navigation_viewmodel;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson/geojson.dart';
import 'package:latlong/latlong.dart';
import 'package:velibetter/core/models/NavigationStep.dart';
import 'package:velibetter/core/services/RouteService.dart';
import 'package:velibetter/ui/arrival_screen/arrival_screen.dart';
import 'package:velibetter/ui/departure_screen/departure_screen.dart';

class NavigationViewModel extends navigation_viewmodel.ChangeNotifier {
  RouteService _routeService = RouteService();
  LatLng departure;
  LatLng arrival;
  GeoJsonFeatureCollection _route;
  List<NavigationStep> _steps;
  MapController mapController = MapController();

  NavigationViewModel({@required this.departure, @required this.arrival});

  List<NavigationStep> get steps => _steps;

  void fetchRoute() async {
    _route = await _routeService.fetchOpenRoute(departure.latitude,
        departure.longitude, arrival.latitude, arrival.longitude);
    notifyListeners();
  }

  void getSteps() async {
    _steps = _routeService.getSteps(_route);
    notifyListeners();
  }

  void getSummary() async {
    _steps = _routeService.getSteps(_route);
    notifyListeners();
  }

  IconData getNavigationIcon(int type) {
    print(type);
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

  void toDeparturePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepartureScreen()),
    );
    notifyListeners();
  }

  void toArrivalPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArrivalScreen()),
    );
    notifyListeners();
  }
}
