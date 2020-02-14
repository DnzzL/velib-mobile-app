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
                          itemCount: model.listStationsWithDocks.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 8.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 1.0),
                              child: Container(
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8.0),
                                  title: Text(
                                    '${model.listStationNameSortedByDistance[index]} (${model.distances[index]} m)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                  subtitle: _getStatusLine(model, index),
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
                          backgroundColor: Colors.blue[500],
                        ),
                ),
              ),
            ));
  }

  Widget _getStatusLine(ArrivalViewModel model, int index) {
    return Row(
      children: <Widget>[
        Container(
          height: 28.0,
          width: 28.0,
          margin: EdgeInsets.fromLTRB(5, 5, 30, 2),
          decoration: ShapeDecoration(
            color: Colors.blue[500],
            shape: CircleBorder(),
          ),
          child: new IconButton(
              iconSize: 13.0,
              icon: new Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: null),
        ),
        Expanded(
            flex: 1,
            child: Container(
              child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  value: model.getAvailability(index),
                  valueColor: AlwaysStoppedAnimation(
                      model.getAvailabilityColor(index))),
            )),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
          child:
              Text("${model.listStationsWithDocks[index].numDocksAvailable}"),
        )
      ],
    );
  }
}
