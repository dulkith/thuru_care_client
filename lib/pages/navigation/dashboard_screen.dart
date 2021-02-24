import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thuru_care_client/models/WeatherModel.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/navigation/camera_screen.dart';
import 'package:thuru_care_client/pages/navigation/result_list.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:thuru_care_client/utils/app_bar.dart';
import 'package:thuru_care_client/utils/dashboard.dart';
import 'package:thuru_care_client/widgets/layoutWidgets.dart';
import 'package:http/http.dart' as http;

LocationData _currentLocation;
String lat;
String lon;

class FirstScreenState extends StatelessWidget {
  FirstScreenState();

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;
  //LocationData _currentLocation;
  StreamSubscription<LocationData> _locationSubscription;

  var _locationService = new Location();
  String error;
  bool _permission = false;

  void initState() {
    super.initState();

    initPlatformState();

    _locationSubscription = _locationService
        .onLocationChanged()
        .listen((LocationData currentLocation) async {
      setState(() {
        _currentLocation = currentLocation;
      });
    });
  }

  void initPlatformState() async {
    try {
      _currentLocation = await _locationService.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }
  }

  Future<WeatherModel> getWeather(String lat, String lng) async {
    final response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lng}&appid=7ccab19f643bc8e132bc7305150b48c4&units=metric');

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var model = WeatherModel.fromJson(result);
      return model;
    } else
      throw Exception('Failed to load Weather Infromation.');
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      lat = "0.0";
      lon = "0.0";
    } else {
      lat = _currentLocation.latitude.toString();
      lon = _currentLocation.longitude.toString();
    }

    return Scaffold(
      appBar: layoutWidgets.appBarWidget(context),
      drawer: layoutWidgets.drawerWidget(context),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: getWeather(lat, lon),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        WeatherModel model = snapshot.data;
                        //Format data
                        var fm = new DateFormat('dd MMMM');
                        var fm_hour = new DateFormat.Hm();
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 8.0, 16.0, 12.0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).primaryColor,
                                  Color(0xFF32CA36)
                                ])), // Yellow
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${model.name}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Today, ${fm.format(new DateTime.fromMillisecondsSinceEpoch((model.dt * 1000), isUtc: true))}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${model.main.temp}°C',
                                          style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${model.weather[0].description}'
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Image.network(
                                      "https://openweathermap.org/img/wn/${model.weather[0].icon}@2x.png",
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  /* Container(
                    // Another fixed-height child.
                    color: const Color(0xff008000), // Green
                    height: 120.0,
                  ), */
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => new CameraHomeScreen(),
            //builder: (context) => new ResultList(),
          ));
        },
        label: Text('Health Check'),
        icon: Icon(ThuruCareIcons.camera),
        heroTag: null,
      ),
    );
  }
}

//Drawer

/* class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription; */
  //LocationData _currentLocation;
  StreamSubscription<LocationData> _locationSubscription;

  var _locationService = new Location();
  String error;
  bool _permission = false;

  void initState() {
    
    super.initState();

    

    initPlatformState();

    _locationSubscription = _locationService
        .onLocationChanged()
        .listen((LocationData currentLocation) async {
      setState(() {
        _currentLocation = currentLocation;
      });
    });
  }

  void initPlatformState() async {
    try {
      _currentLocation = await _locationService.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = 'Permission denied';
      }
      _currentLocation = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if(_currentLocation == null){
      lat = "0.0";
      lon = "0.0";
    }else{
      lat = _currentLocation.latitude.toString();
      lon = _currentLocation.longitude.toString();
    }

    /* lat = _currentLocation.latitude.toString();
    lon = _currentLocation.longitude.toString(); */
    

    return Scaffold(
      body: new Column(
        children: <Widget>[
          Dashboard(lat, lon),
        ],
      ),
      appBar: layoutWidgets.appBarWidget(),
      drawer: layoutWidgets.drawerWidget(context),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => new CameraHomeScreen(),
            //builder: (context) => new ResultList(),
          ));
        },
        label: Text('Health Check'),
        icon: Icon(ThuruCareIcons.camera),
        heroTag: null,
      ),
    );
  }
}
 */
