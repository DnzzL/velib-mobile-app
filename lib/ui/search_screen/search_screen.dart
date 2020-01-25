import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:search_page/search_page.dart';
import 'package:velibetter/core/models/Station.dart';
import 'package:velibetter/ui/search_screen/search_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<SearchViewModel>.withConsumer(
      viewModel: SearchViewModel(),
      onModelReady: (model) => model.fetchStations(),
      builder: (context, model, child) => Scaffold(
        body: FloatingActionButton(
          child: Icon(Icons.search),
          tooltip: 'Search station',
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<Station>(
              items: model.listStations,
              searchLabel: 'Search station',
              suggestion: Center(
                child: Text('Filter station by name, or code'),
              ),
              failure: Center(
                child: Text('No person found :('),
              ),
              filter: (station) => [
                station.name,
                station.stationCode
              ],
              builder: (station) => ListTile(
                title: Text(station.name),
                subtitle: Text(station.stationCode),
                trailing: Text('${station.lat} ${station.lon}'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
