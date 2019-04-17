import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';
import 'package:thuru_care_client/utils/my_navigator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFullscreen(true);
    Timer(Duration(seconds: 5), () => MyNavigator.goToIntro(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.green,
                  Colors.lightGreen,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: Alignment(0.8, 5.0), 
                stops: [0.0, 0.5],
                tileMode: TileMode.clamp),
          ),
        ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        backgroundImage:
                        AssetImage('assets/logo.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        ThuruCare.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      Text(
                        ThuruCare.version,
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 10.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black54),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      ThuruCare.captionLoading,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic, // italic
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  static setFullscreen(bool value) {
    if (value) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }
}
