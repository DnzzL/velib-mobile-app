import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/ui/arrival_screen/arrival_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class ArrivalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<ArrivalViewModel>.withConsumer(
        viewModel: ArrivalViewModel(),
        onModelReady: (model) => model.getClosestStationsWithDocks(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                child: Container(
                  child: model.listStations != null
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
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
                                    child:
                                        Icon(Icons.store, color: Colors.white),
                                  ),
                                  title: Text(
                                    '${model.listStationNameSortedByDistance[index]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.equalizer,
                                        color:
                                            model.getAvailabilityColor(index),
                                        size: 18,
                                      ),
                                      Text(
                                          model.listStations != null
                                              ? ' Docks available: ${model.listStationsWithBikes[index].numDocksAvailable}'
                                              : ' 0',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right,
                                      color: Colors.white, size: 30.0),
                                  onTap: () => print("nav"),
                                ),
                              ),
                            );
                          },
                        )
                      : LoadingDoubleFlipping.circle(
                          backgroundColor: Colors.blueAccent,
                        ),
                ),
              ),
            ));
  }
}
