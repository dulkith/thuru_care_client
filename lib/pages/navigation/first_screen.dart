import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FirstScreenState extends StatelessWidget {
 final Color color;

 FirstScreenState(this.color);

 @override
 Widget build(BuildContext context) {
   return Scaffold( 
      body: Container(
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
      
    );
  }
}

// Dashboard Icons
Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
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
                  size: 40.0,
                  color: Color.fromARGB(180, 0, 100, 0),
                )),
                SizedBox(height: 10.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 14.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }


