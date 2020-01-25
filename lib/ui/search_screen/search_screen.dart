import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:velibetter/ui/search_screen/search_viewmodel.dart';

// Since the state was moved to the view model, this is now a StatelessWidget.
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModelProvider is what provides the view model to the widget tree.
    return ViewModelProvider<SearchViewModel>.withConsumer(
        viewModel: SearchViewModel(),
        onModelReady: (model) => model.fetchClosestStations(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 0.0),
                      child: TextField(
                        onChanged: (value) => model.filterItems(value),
                        controller: model.editingController,
                        decoration: InputDecoration(
                            labelText: "Destination",
                            hintText: "Destination",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                    Expanded(
                      child: model.filteredStations != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.filteredStations != null
                                  ? model.filteredStations.length
                                  : 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      '${model.filteredStations[index].name}'),
                                );
                              },
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.listStations != null
                                  ? model.listStations.length
                                  : 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title:
                                      Text('${model.listStations[index].name}'),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
