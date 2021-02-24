import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:thuru_care_client/models/WeatherModel.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:thuru_care_client/utils/assets.dart';
import 'package:thuru_care_client/utils/intro/circles_with_image.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatelessWidget {
  String nlat;
  String nlon;

  Dashboard(String lat, String lng){
    this.nlat = lat;
    this.nlon = lng;
  }
/* 
  Future<WeatherModel> getWeather(String lat, String lng) async {
    final responce = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=7ccab19f643bc8e132bc7305150b48c4&units=metric');

    if (responce.statusCode == 200) {
      var result = json.decode(responce.body);
      var model = WeatherModel.fromJson(result);
      return model;
    } else
      throw Exception('Failed to load Weather Infromation.');
  } */

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new Container(
        decoration: new BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.green[600],
          Colors.green[300],
          Colors.lightGreen[100],
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0))),
        child: Stack(
          children: <Widget>[
            new Positioned(
              child: new CircleWithImage(Assets.logo),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            new Positioned.fill(
              child: GridView.count(
                crossAxisCount: 3,
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  makeDashboardItem("Library", ThuruCareIcons.leaf),
                  makeDashboardItem("Community", ThuruCareIcons.graduation_cap),
                  makeDashboardItem("Nearby", ThuruCareIcons.location),
                  makeDashboardItem("My Profile", ThuruCareIcons.user),
                  makeDashboardItem("Gallery", ThuruCareIcons.gallery),
                  makeDashboardItem("Write Post", ThuruCareIcons.pencil),
                  makeDashboardItem("Login", ThuruCareIcons.login),
                  makeDashboardItem("Settings", ThuruCareIcons.cog),
                  makeDashboardItem("Help", ThuruCareIcons.question_circle),
                ],
              ),
            ),
            /* new Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height - 280),
                child: FutureBuilder<WeatherModel>(
                  future: getWeather(nlat, nlon),
                  builder: (context, snashot) {
                    if (snashot.hasData) {
                      WeatherModel model = snashot.data;
                      //Format data
                      var fm = new DateFormat('dd MMMM');
                      var fm_hour = new DateFormat.Hm();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${model.name}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Today, ${fm.format(new DateTime.fromMillisecondsSinceEpoch((model.dt * 1000), isUtc: true))}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.w300),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.network(
                                      'https://openweathermap.org/img/w/${model.weather[0].icon}.png'),
                                  Text(
                                    '${model.main.temp}°C',
                                    style: TextStyle(
                                        fontSize: 36,
                                        color: Colors.brown,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Text(
                                  '${model.weather[0].description}'
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.brown[700],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                'Wind (Speed/Deg): ${model.wind.speed}/${model.wind.deg}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Pressure: ${model.main.pressure}hpa',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Humidity: ${model.main.humidity}%',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Sunset: ${fm_hour.format(new DateTime.fromMillisecondsSinceEpoch(model.sys.sunset))} PM',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snashot.hasError)
                      return Text(
                        '${snashot.error}',
                        style: TextStyle(fontSize: 10, color: Colors.redAccent),
                      );
                    return CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.teal[900]),
                    );
                    //return Text('${snashot.data.name}', style: TextStyle(fontSize: 30, color: Colors.white),);
                  },
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

// Dashboard Icons
Card makeDashboardItem(String title, IconData icon) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    elevation: 1.0,
    margin: new EdgeInsets.all(6.0),
    child: new InkWell(
      onTap: () {
        print("tapped");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(60, 60, 70, 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.green,
              blurRadius: 1.0,
              offset: new Offset(0.0, 5.0),
            ),
          ],
        ),
        child: new InkWell(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 20.0),
              Center(
                  child: Icon(
                icon,
                size: 41.0,
                color: Color.fromARGB(200, 70, 200, 0),
              )),
              SizedBox(height: 10.0),
              new Center(
                child: new Text(title,
                    style: new TextStyle(fontSize: 15.0, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
