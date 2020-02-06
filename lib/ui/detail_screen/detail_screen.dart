import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/ui/detail_screen/detail_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<DetailViewModel>.withConsumer(
      viewModel: DetailViewModel(),
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
                          'Rue du faubourg saint-antoine',
                          style: TextStyle(color: Colors.white, fontSize: 40.0),
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
                            Text('(53.113, 2.133)',
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
              child: Text('Status', style: TextStyle(fontSize: 30.0)),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Icon(
                  CommunityMaterialIcons.check,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('Available for departures'),
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
                Icon(
                  Icons.clear,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('Available for arrivals'),
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
                Icon(
                  CommunityMaterialIcons.bike,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('2 mechanicals'),
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
                Icon(
                  CommunityMaterialIcons.flash,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('2 ebike')
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
                Icon(
                  CommunityMaterialIcons.garage_open,
                ),
                SizedBox(
                  width: 15,
                ),
                Text('2 docks')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
