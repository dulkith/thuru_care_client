import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Flexible(
      child: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/fruits_and_vegitables.png"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomLeft,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          child: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(3.0),
            children: <Widget>[
              makeDashboardItem("Diseases", FontAwesomeIcons.leaf),
              makeDashboardItem("Community", Icons.comment),
              makeDashboardItem("Nearby", Icons.location_on),
              makeDashboardItem("My Profile", FontAwesomeIcons.solidUserCircle),
              makeDashboardItem("Gallery", FontAwesomeIcons.images),
              makeDashboardItem("Register", FontAwesomeIcons.userPlus),
              makeDashboardItem("Login", FontAwesomeIcons.signInAlt),
              makeDashboardItem("Settings", Icons.settings),
              makeDashboardItem("Help", Icons.help_outline),
            ],
          ),
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
  );
}
