import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/ui/departure_screen/departure_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class DepartureScreen extends StatelessWidget {
  final List<StationInfo> listStationInfo;
  final List<StationStatus> listStationStatus;

  DepartureScreen(
      {Key key,
      @required this.listStationInfo,
      @required this.listStationStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<DepartureViewModel>.withConsumer(
        viewModel: DepartureViewModel(
            listStationInfo: listStationInfo,
            listStationStatus: listStationStatus),
        onModelReady: (model) => model.getClosestStationsWithBikes(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                child: Container(
                    child: model.listStationsWithBikes != null &&
                            model.listStationNameSortedByDistance != null
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: model.listStationsWithBikes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 2.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 1.0),
                                child: Container(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 14.0),
                                    title: Text(
                                      '${model.listStationNameSortedByDistance[index]} (${model.distances[index]} m)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                                    subtitle: Column(
                                      children: <Widget>[
                                        _getStatusLine(
                                            model, index, "mechanical"),
                                        _getStatusLine(model, index, "ebike")
                                      ],
                                    ),
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
                            backgroundColor: Colors.blue[500],
                          )),
              ),
            ));
  }

  Widget _getStatusLine(DepartureViewModel model, int index, String bikeType) {
    return Row(
      children: <Widget>[
        Container(
          height: 28.0,
          width: 28.0,
          margin: EdgeInsets.fromLTRB(5, 5, 30, 2),
          decoration: ShapeDecoration(
            color: bikeType == "mechanical"
                ? Color(0xFF84BF48)
                : Color(0xFF65BEC2),
            shape: CircleBorder(),
          ),
          child: new IconButton(
              iconSize: 13.0,
              icon: new Icon(
                Icons.directions_bike,
                color: Colors.white,
              ),
              onPressed: null),
        ),
        Expanded(
            flex: 1,
            child: Container(
              child: LinearProgressIndicator(
                  backgroundColor: Color(0xFFE0E0E0),
                  value: model.getAvailability(index, bikeType),
                  valueColor: AlwaysStoppedAnimation(
                      model.getAvailabilityColor(index, bikeType))),
            )),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
          child: bikeType == "mechanical"
              ? Text(
                  "${model.listStationsWithBikes[index].numBikesAvailableTypes.mechanical}")
              : Text(
                  "${model.listStationsWithBikes[index].numBikesAvailableTypes.ebike}"),
        )
      ],
    );
  }
}
