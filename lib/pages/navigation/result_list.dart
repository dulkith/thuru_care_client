import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/navigation/diseases_result_detail_display.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';

class ResultList extends StatelessWidget {
  var predictionsList;

  ResultList(this.predictionsList);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new WillPopScope(
        child: new Scaffold(
          appBar: AppBar(
            title: Text('Crop leaf scan results...'),
            backgroundColor: Colors.green[600],
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.search), onPressed: () => null),
              new IconButton(
                icon: new Icon(Icons.close),
                onPressed: () => HomeScreen(),
              ),
            ],
          ),
          body: BodyLayout(predictionsList),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.cyan[500],
            foregroundColor: Colors.white,
            onPressed: () async {},
            label: Text('Not Satisfied!'),
            icon: Icon(ThuruCareIcons.sad),
            heroTag: null,
          ),
        ),
        onWillPop: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => new HomeScreen(),
          ));
        },
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  var predictionsList;

  BodyLayout(this.predictionsList);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new SizedBox(
            height: 10,
          ),
          new Expanded(
            child: ListView.separated(
              itemCount: 8,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: Image.network(
                        "http://35.247.186.2:9000/static/" +
                            predictionsList[index].disease +
                            ".jpg",
                        height: 65,
                        width: 90,
                        fit: BoxFit.fill),
                  ),
                  title: Text(
                      '${predictionsList[index].disease[0].toUpperCase()}${predictionsList[index].disease.substring(1)}'),
                  subtitle: Row(
                    children: <Widget>[
                      new LinearPercentIndicator(
                        width: 100.0,
                        lineHeight: 6.0,
                        percent: predictionsList[index].prediction,
                        progressColor: Colors.green,
                      ),
                      Text(getPercentage(predictionsList[index].prediction) +
                          "%"),
                    ],
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    if (!predictionsList[index].disease.contains('healthy')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ResultDetailPage(predictionsList[index].disease),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RichAlertDialog(
                            //uses the custom alert dialog
                            alertTitle: richTitle("Crop is Healthy!"),
                            alertSubtitle: richSubtitle(
                                "Crop looking good, If you're not satisfied\n post it in Our Community for expert support."),
                            alertType: RichAlertType.SUCCESS,
                          );
                        },
                      );
                    }
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          )
        ],
      ),
    );
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  return ListView();
}

String getPercentage(double val) {
  double newVal = val * 100;
  double mod = pow(10.0, 2);
  return ((newVal * mod).round().toDouble() / mod).toString();
}
