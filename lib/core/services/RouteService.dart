import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geojson/geojson.dart';
import 'package:velibetter/core/models/NavigationStep.dart';

class RouteService {
  DefaultCacheManager cacheManager = DefaultCacheManager();

  Future<GeoJsonFeatureCollection> fetchOpenRoute(
      double latA, double lonA, double latB, double lonB) async {
    await DotEnv().load('.env');
    var url =
        'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=${DotEnv().env['OPENROUTE_TOKEN']}&start=$lonA,$latA&end=$lonB,$latB';
    try {
      var file = await cacheManager.getSingleFile(url);
      var response = file.readAsStringSync();
      final features = await featuresFromGeoJson(response);
      return features;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  List<NavigationStep> getSteps(GeoJsonFeatureCollection collection) {
    return List<NavigationStep>.from(collection
        .collection[0].properties["segments"][0]["steps"]
        .map((e) => NavigationStep.fromJson(e))
        .toList());
  }

  GeoJsonLine getTrace(GeoJsonFeatureCollection collection) {
    return collection.collection[0].geometry;
  }

  Map<String, double> getSummary(GeoJsonFeatureCollection collection) {
    return Map<String, double>.from(
        collection.collection[0].properties["summary"]);
  }
}
