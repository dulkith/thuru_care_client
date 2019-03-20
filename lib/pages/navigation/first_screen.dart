import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

const String _AccountName = 'Dulkith Bataduwa';
const String _AccountEmail = 'dulkith.2016210@iit.ac.lk';
const String _AccountAbbr = 'D';

class FirstScreenState extends StatelessWidget {
 
 

 FirstScreenState();

 @override
 Widget build(BuildContext context) {
   return Scaffold( 
     appBar: AppBar(
        title: Center(
        child: new Image.asset('assets/title.png', fit: BoxFit.cover,)
      ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          Padding(
            child: Icon(Icons.search),
            padding: const EdgeInsets.only(right: 10.0),
          )
        ],
      ),
            drawer: new Drawer(
          child: new ListView(
              padding: const EdgeInsets.only(top: 0.0),
              children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: const Text(_AccountName),
                accountEmail: const Text(_AccountEmail),
                currentAccountPicture: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text(_AccountAbbr,
                        style: new TextStyle(
                            fontSize: 45.0, fontWeight: FontWeight.w400))),
                otherAccountsPictures: <Widget>[
                  new GestureDetector(
                    onTap: () => _onTapOtherAccounts(context),
                    child: new Semantics(
                      label: 'Switch Account',
                      child: new CircleAvatar(
                        backgroundColor: Colors.white,
                        child: new Text('IIT'),
                      ),
                    ),
                  )
                ]),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.home),
              title: new Text(ThuruCare.drawerHome),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.leaf),
              title: new Text(ThuruCare.drawerDiseasesDiag),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.solidCommentAlt),
              title: new Text(ThuruCare.drawerComSupport),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.mapMarkerAlt),
              title: new Text(ThuruCare.drawerNearGarden),
              onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Text(ThuruCare.drawerUserProManager),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.userTie),
              title: new Text(ThuruCare.drawerMyProfile),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.signInAlt),
              title: new Text(ThuruCare.drawerLogin),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.userPlus),
              title: new Text(ThuruCare.drawerRegister),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.userEdit),
              title: new Text(ThuruCare.drawerEditProfile),
              onTap: () => _onListTileTap(context),
            ),

            new Divider(),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.key),
              title: new Text(ThuruCare.drawerChangePass),
              onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text(ThuruCare.drawerSettings),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.help_outline),
              title: new Text(ThuruCare.drawerHelpAndFeed),
              onTap: () => _onListTileTap(context),
            )
          ])),
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

//Drawer

_onTapOtherAccounts(BuildContext context) {
  Navigator.of(context).pop();
  showDialog<Null>(
    context: context,
    child: new AlertDialog(
      title: const Text('Account switching not implemented.'),
      actions: <Widget>[
        new FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

_onListTileTap(BuildContext context) {
  Navigator.of(context).pop();
  showDialog<Null>(
    context: context,
    child: new AlertDialog(
      title: const Text('Not Implemented'),
      actions: <Widget>[
        new FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

