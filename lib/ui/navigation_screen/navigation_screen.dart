import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/ui/navigation_screen/navigation_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class NavigationScreen extends StatelessWidget {
  final LatLng departure;
  final LatLng arrival;

  NavigationScreen({Key key, @required this.departure, @required this.arrival})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<NavigationViewModel>.withConsumer(
      viewModel:
          NavigationViewModel(departure: this.departure, arrival: this.arrival),
      onModelReady: (model) {
        model.fetchRoute();
        model.getSteps();
        model.getSummary();
      },
      builder: (context, model, child) => Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.tightForFinite(height: 250),
              margin: EdgeInsets.all(0),
              child: FlutterMap(
                mapController: model.mapController,
                options: new MapOptions(
                  center: model.departure,
                  zoom: 16.0,
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  new MarkerLayerOptions(markers: [
                    new Marker(
                      width: 30.0,
                      height: 30.0,
                      point: model.departure,
                      builder: (ctx) => new Container(
                        child: Icon(
                          Icons.my_location,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    new Marker(
                      width: 30.0,
                      height: 30.0,
                      point: model.arrival,
                      builder: (ctx) => new Container(
                        child: Icon(
                          CommunityMaterialIcons.flag_checkered,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            Flexible(
              child: model.steps != null
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: model.steps.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                  padding:
                                      EdgeInsets.only(right: 12.0, top: 8.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: Icon(model.getNavigationIcon(
                                      model.steps[index].type))),
                              title: Text(
                                '${model.steps[index].instruction}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                              subtitle: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.linear_scale,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text(' ${model.steps[index].distance} m',
                                      style: TextStyle(color: Colors.white)),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  Icon(
                                    Icons.av_timer,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text(' ${model.steps[index].duration} s',
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
