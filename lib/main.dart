import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/intro_screen.dart';
import 'package:thuru_care_client/pages/splash_screen.dart';

Future<Null> main() async {
  runApp(new MyApp());
}

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme:
        ThemeData(primaryColor: Colors.green, accentColor: Colors.greenAccent,fontFamily: 'Ubuntu'),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes);
  }
}