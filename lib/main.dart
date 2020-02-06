import 'package:flutter/material.dart';
import 'package:velibetter/ui/detail_screen/detail_screen.dart';
import 'package:velibetter/ui/map_screen/map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velibetter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DetailScreen(),
    );
  }
}
