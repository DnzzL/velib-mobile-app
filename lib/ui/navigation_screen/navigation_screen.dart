import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:loading_animations/loading_animations.dart';
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
        model.localizeUserLive();
        model.getSummary();
        model.getSteps();
        model.getTrace();
      },
      builder: (context, model, child) => Scaffold(
          body: model.points != null &&
                  model.steps != null &&
                  model.summary != null
              ? Column(
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
                          PolylineLayerOptions(
                            polylines: [
                              Polyline(
                                  points: model.points,
                                  strokeWidth: 4.0,
                                  color: Colors.deepPurple[300]),
                            ],
                          ),
                          new MarkerLayerOptions(markers: [
                            new Marker(
                              width: 30.0,
                              height: 30.0,
                              point: model.departure,
                              builder: (ctx) => new Container(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.blue[500],
                                ),
                              ),
                            ),
                            new Marker(
                              width: 30.0,
                              height: 30.0,
                              point: model.userPosition,
                              builder: (ctx) => new Container(
                                child: Icon(
                                  Icons.my_location,
                                  color: Colors.green[500],
                                ),
                              ),
                            ),
                            new Marker(
                              width: 30.0,
                              height: 30.0,
                              point: model.arrival,
                              builder: (ctx) => new Container(
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red[500],
                                ),
                              ),
                            ),
                          ]),

                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text('Summary',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            Card(
                              elevation: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.linear_scale),
                                  Text(' ${model.summary["distance"]} m'),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Icon(Icons.av_timer),
                                  Text(
                                      ' ${(model.summary["duration"] / 60).toStringAsFixed(1)} min')
                                ],
                              ),
                            )
                          ],
                        )),
                    Expanded(
                      child: model.steps != null
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: model.steps.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    leading: Container(
                                        padding: EdgeInsets.only(
                                            right: 12.0, top: 6.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(
                                                    width: 1.0,
                                                    color: Colors.green))),
                                        child: Icon(model.getNavigationIcon(
                                            model.steps[index].type))),
                                    title: Text(
                                      '${model.steps[index].instruction}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                    subtitle: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.linear_scale,
                                          size: 20,
                                        ),
                                        Text(
                                            ' ${model.steps[index].distance} m'),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Icon(
                                          Icons.av_timer,
                                          size: 20,
                                        ),
                                        Text(
                                            ' ${(model.steps[index].duration / 60).toStringAsFixed(1)} min')
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(),
                    )
                  ],
                )
              : LoadingDoubleFlipping.circle(
                  backgroundColor: Colors.blueAccent,
                )),
    );
  }
}
