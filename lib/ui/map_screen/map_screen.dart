import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/ui/map_screen/map_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<MapViewModel>.withConsumer(
      viewModel: MapViewModel(),
      onModelReady: (model) {
        model.localizeUserLive();
        model.getStationMarkers(context);
      },
      builder: (context, model, child) => Scaffold(
        body: FlutterMap(
          mapController: model.mapController,
          options: new MapOptions(
            center: LatLng(48.857607, 2.3473629999999996),
            zoom: 14.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            new MarkerLayerOptions(
              markers: model.listStationsMarkers != null
                  ? [
                      ...model.listStationsMarkers,
                      new Marker(
                        width: 30.0,
                        height: 30.0,
                        point: model.userPosition,
                        builder: (ctx) => new Container(
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blue[500],
                          ),
                        ),
                      ),
                    ]
                  : [],
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Color(0xFF8448bf),
          animatedIcon: AnimatedIcons.menu_close,
          marginRight: 25.0,
          children: [
            SpeedDialChild(
                child: Icon(Icons.directions_bike),
                backgroundColor: Colors.blueAccent,
                label: "Departure",
                onTap: () => model.toDeparturePage(context)),
            SpeedDialChild(
                child: Icon(Icons.build),
                backgroundColor: Colors.red[500],
                label: "Arrival",
                onTap: () => model.toArrivalPage(
                    context, model.listStationInfo, model.listStationStatus)),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
