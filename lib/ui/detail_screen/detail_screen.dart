import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/core/models/StationInfo.dart';
import 'package:velibetter/core/models/StationStatus.dart';
import 'package:velibetter/ui/detail_screen/detail_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class DetailScreen extends StatelessWidget {
  int stationIndex;
  List<StationInfo> listStationInfo;
  List<StationStatus> listStationStatus;

  DetailScreen(
      {Key key,
      @required this.stationIndex,
      @required this.listStationInfo,
      @required this.listStationStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<DetailViewModel>.withConsumer(
      viewModel: DetailViewModel(
          stationIndex: this.stationIndex,
          listStationInfo: this.listStationInfo,
          listStationStatus: this.listStationStatus),
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 10.0),
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("assets/images/station.jpg"),
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  padding: EdgeInsets.all(40.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.listStationInfo[model.stationIndex].name,
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                        Container(
                          width: 80.0,
                          child: new Divider(color: Colors.green),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              CommunityMaterialIcons.compass,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                                '(${model.listStationInfo[model.stationIndex].lat.toStringAsFixed(3)}, ${model.listStationInfo[model.stationIndex].lon.toStringAsFixed(3)})',
                                style: TextStyle(color: Colors.white))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment(-1, 0),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('Status', style: TextStyle(fontSize: 24.0)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children:
                      model.listStationStatus[model.stationIndex].isRenting
                          ? <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 32.0,
                                width: 32.0,
                                decoration: ShapeDecoration(
                                  color: Colors.lightGreen,
                                  shape: CircleBorder(),
                                ),
                                child: new IconButton(
                                    iconSize: 16.0,
                                    icon: new Icon(
                                      CommunityMaterialIcons.check,
                                      color: Colors.white,
                                    ),
                                    onPressed: null),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Open for departures'),
                            ]
                          : <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 32.0,
                                width: 32.0,
                                decoration: ShapeDecoration(
                                  color: Colors.red,
                                  shape: CircleBorder(),
                                ),
                                child: new IconButton(
                                    iconSize: 16.0,
                                    icon: new Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    onPressed: null),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Closed for departures'),
                            ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children:
                      model.listStationStatus[model.stationIndex].isReturning
                          ? <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 32.0,
                                width: 32.0,
                                decoration: ShapeDecoration(
                                  color: Colors.lightGreen,
                                  shape: CircleBorder(),
                                ),
                                child: new IconButton(
                                    iconSize: 16.0,
                                    icon: new Icon(
                                      CommunityMaterialIcons.check,
                                      color: Colors.white,
                                    ),
                                    onPressed: null),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Open for arrivals'),
                            ]
                          : <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 32.0,
                                width: 32.0,
                                decoration: ShapeDecoration(
                                  color: Colors.red,
                                  shape: CircleBorder(),
                                ),
                                child: new IconButton(
                                    iconSize: 16.0,
                                    icon: new Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    onPressed: null),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text('Closed for arrivals'),
                            ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment(-1, 0),
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text('Availibility', style: TextStyle(fontSize: 24.0)),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: ShapeDecoration(
                        color: Colors.blue,
                        shape: CircleBorder(),
                      ),
                      child: new IconButton(
                          iconSize: 16.0,
                          icon: new Icon(
                            CommunityMaterialIcons.bike,
                            color: Colors.white,
                          ),
                          onPressed: null),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                        '${model.listStationStatus[model.stationIndex].numBikesAvailableTypes.mechanical} mechanicals'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: ShapeDecoration(
                        color: Colors.blue,
                        shape: CircleBorder(),
                      ),
                      child: new IconButton(
                          iconSize: 16.0,
                          icon: new Icon(
                            CommunityMaterialIcons.flash,
                            color: Colors.white,
                          ),
                          onPressed: null),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                        '${model.listStationStatus[model.stationIndex].numBikesAvailableTypes.ebike} ebike')
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: ShapeDecoration(
                        color: Colors.blue,
                        shape: CircleBorder(),
                      ),
                      child: new IconButton(
                          iconSize: 16.0,
                          icon: new Icon(
                            CommunityMaterialIcons.home,
                            color: Colors.white,
                          ),
                          onPressed: null),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                        '${model.listStationStatus[model.stationIndex].numDocksAvailable} docks')
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      color: Color(0xFFC5E1A5),
                      textColor: Color(0xFF1B5E20),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(10.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () => model.toNavigationPage(
                          context, model.listStationInfo[model.stationIndex]),
                      child: Text(
                        "Start from here",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      color: Color(0xFFFFCDD2),
                      textColor: Color(0xFFB71C1C),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(10.0),
                      splashColor: Colors.blueAccent,
                      onPressed: () => model.toNavigationPage(
                          context, model.listStationInfo[model.stationIndex]),
                      child: Text(
                        "Arrive here",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
