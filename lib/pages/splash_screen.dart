import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thuru_care_client/utils/assets.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';
import 'package:thuru_care_client/utils/my_navigator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future checkSplashScreen() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool _firstRun = (preferences.getBool('firstRun') ?? false);
    if(_firstRun){
      MyNavigator.goToHome(context);
    }else{
      _firstRun = await preferences.setBool("firstRun", true);
      MyNavigator.goToIntro(context);
    }
    
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    
    //setFullscreen(true);
    Timer(Duration(seconds: 4), () => checkSplashScreen());
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/fruits_and_vegitables.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomLeft,
            ),
            color: Colors.white
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
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset('assets/logo.png')),
                      
                      
                      
                      Text(
                        ThuruCare.version,
                        style: TextStyle(
                            color: Colors.green[700],
                            fontStyle: FontStyle.italic,
                            fontSize: 10.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom:20.0),
                      child: CircularProgressIndicator(
                        
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.0),
                    ),
                    Text(
                      ThuruCare.captionLoading,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic, // italic
                          color: Colors.green[900]),
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
