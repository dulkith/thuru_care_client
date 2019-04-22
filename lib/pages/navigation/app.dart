import 'package:flutter/material.dart';
import 'package:thuru_care_client/pages/home_screen.dart';

class App extends StatelessWidget {
  var cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen());
  }
}