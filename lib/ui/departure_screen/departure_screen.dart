import 'package:community_material_icon/community_material_icon.dart';
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
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(64, 75, 96, .9)),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 10.0),
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
                                          CommunityMaterialIcons.bike,
                                          color: model.getAvailabilityColor(
                                              index, "mechanical"),
                                          size: 18,
                                        ),
                                        Text(
                                            model.listStationStatus != null
                                                ? ' Mechanical: ${model.listStationsWithBikes[index].numBikesAvailableTypes.mechanical}'
                                                : ' 0',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Icon(
                                          Icons.flash_on,
                                          color: model.getAvailabilityColor(
                                              index, "ebike"),
                                          size: 18,
                                        ),
                                        Text(
                                            model.listStationStatus != null
                                                ? ' Ebike: ${model.listStationsWithBikes[index].numBikesAvailableTypes.ebike}'
                                                : '0',
                                            style:
                                                TextStyle(color: Colors.white))
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
                          )),
              ),
            ));
  }
}
