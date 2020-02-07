import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/ui/arrival_screen/arrival_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class ArrivalScreen extends StatelessWidget {
  final List<StationInfo> listStationInfo;
  final List<StationStatus> listStationStatus;

  ArrivalScreen(
      {Key key,
      @required this.listStationInfo,
      @required this.listStationStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<ArrivalViewModel>.withConsumer(
        viewModel: ArrivalViewModel(
            listStationInfo: listStationInfo,
            listStationStatus: listStationStatus),
        onModelReady: (model) => model.getClosestStationsWithDocks(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                child: Container(
                  child: model.listStationNameSortedByDistance != null
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
                                    color: Color.fromRGBO(64, 75, 96, .9)),
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
                                  subtitle: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 10.0),
                                            child: Text("docks",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          LinearProgressIndicator(
                                              backgroundColor: Color.fromRGBO(
                                                  209, 224, 224, 0.2),
                                              value: model
                                                  .getAvailability(index)
                                                  .toDouble(),
                                              valueColor:
                                                  AlwaysStoppedAnimation(model
                                                      .getAvailabilityColor(
                                                          index))),
                                          Text(
                                              '${model.listStationStatus[index].numDocksAvailable}',
                                              style: TextStyle(
                                                  color: Colors.white))
                                        ],
                                      )),
                                    ],
                                  ),

                                  trailing: Icon(Icons.keyboard_arrow_right,
                                      color: Colors.white, size: 30.0),
                                  onTap: () => model.toNavigationPage(
                                      context,
                                      model.listStationsWithDocks[index]
                                          .stationId),
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
