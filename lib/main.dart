import 'package:flutter/material.dart';
import 'package:velibetter/ui/map_screen/map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Velibetter',
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: Color(0xFFEEEEEE),
        primaryColor: Color(0xFF4CAF50),

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0),
        ),
      ),
      home: MapScreen(),
    );
  }
}
