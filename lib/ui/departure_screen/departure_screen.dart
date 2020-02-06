import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/ui/departure_screen/departure_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class DepartureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<DepartureViewModel>.withConsumer(
        viewModel: DepartureViewModel(),
        onModelReady: (model) => model.getClosestStationsWithBikes(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                child: Container(
                    child: model.listStationStatus != null
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(64, 75, 96, .9),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    title: Text(
                                      '${model.listStationNameSortedByDistance[index]}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: Text("mechanical",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  // tag: 'hero',
                                                  child: LinearProgressIndicator(
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              209, 224, 224, 0.2),
                                                      value: model.getAvailability(
                                                          index, "mechanical"),
                                                      semanticsLabel: model
                                                          .listStationsWithBikes[
                                                              index]
                                                          .numBikesAvailableTypes
                                                          .mechanical
                                                          .toString(),
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              model.getAvailabilityColor(
                                                                  index,
                                                                  "mechanical"))),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: Text("ebike",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Container(
                                                  // tag: 'hero',
                                                  child: LinearProgressIndicator(
                                                      backgroundColor:
                                                          Color.fromRGBO(
                                                              209, 224, 224, 0.2),
                                                      value:
                                                          model.getAvailability(
                                                              index, "ebike"),
                                                      semanticsLabel: model
                                                          .listStationsWithBikes[
                                                              index]
                                                          .numBikesAvailableTypes
                                                          .ebike
                                                          .toString(),
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              model.getAvailabilityColor(
                                                                  index,
                                                                  "ebike"))),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right,
                                        color: Colors.white, size: 30.0),
                                    onTap: () => model.toNavigationPage(
                                        context,
                                        model.listStationsWithBikes[index]
                                            .stationId),
                                  ),
                                ),
                              );
                            },
                          )
                        : LoadingDoubleFlipping.circle(
                            backgroundColor: Colors.blueAccent,
                          )),
              ),
            ));
  }
}
