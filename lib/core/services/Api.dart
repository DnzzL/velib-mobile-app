import 'package:velibetter/core/models/StationStatus.dart';
import 'package:http/http.dart' as http;

class Api {
  var root = "http://127.0.01:8000";

//  void fetchNumberBikesAtStation(int stationId) async {
//    var url = '$root/state/$stationId';
//    var response = await http.get(url);
//    print('Response status: ${response.statusCode}');
//    print('Response body: ${response.body}');
//    var body = response.body as Map<String, int>;
//    StationStatus(...body);
//  }
}
