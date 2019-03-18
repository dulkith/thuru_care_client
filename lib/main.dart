import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/intro_screen.dart';
import 'package:thuru_care_client/pages/splash_screen.dart';


List<CameraDescription> cameras;

Future<Null> main() async {
  cameras = await availableCameras();
  runApp(new MyApp());
}

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(cameras),
  "/intro": (BuildContext context) => IntroScreen(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme:
        ThemeData(primaryColor: Colors.green, accentColor: Colors.greenAccent,fontFamily: 'ProximaNova'),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes);
  }
}