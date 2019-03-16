import 'package:flutter/material.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String _AccountName = 'Dulkith Bataduwa';
const String _AccountEmail = 'dulkith.2016210@iit.ac.lk';
const String _AccountAbbr = 'D';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animCtrl;
  Animation<double> animation;

  AnimationController animCtrl2;
  Animation<double> animation2;

  bool showFirst = true;

  int _selectedIndex = 0;
  final _widgetOptions = [
    Text('Index 0: Home'),
    Text('Index 1: Diseases'),
    Text('Index 2: Community'),
    Text('Index 3: Nearby'),
    Text('Index 5: Profile'),
  ];

  @override
  void initState() {
    super.initState();

    // Animation init
    animCtrl = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    animation = new CurvedAnimation(parent: animCtrl, curve: Curves.easeOut);
    animation.addListener(() {
      this.setState(() {});
    });
    animation.addStatusListener((AnimationStatus status) {});

    animCtrl2 = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    animation2 = new CurvedAnimation(parent: animCtrl2, curve: Curves.easeOut);
    animation2.addListener(() {
      this.setState(() {});
    });
    animation2.addStatusListener((AnimationStatus status) {});
  }

  @override
  void dispose() {
    animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ThuruCare.name),
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
              leading: new Icon(Icons.home),
              title: new Text('Home'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.local_hospital),
              title: new Text('Diseases Diagnosis'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.comment),
              title: new Text('Community Support'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.location_on),
              title: new Text('Nearby Gardens'),
              onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Text('User Profile Manager'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.signInAlt),
              title: new Text('Login'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.userPlus),
              title: new Text('Register'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.userEdit),
              title: new Text('Edit Profile'),
              onTap: () => _onListTileTap(context),
            ),

            new Divider(),
            new ListTile(
              leading: new Icon(FontAwesomeIcons.key),
              title: new Text('Change Password'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Trash'),
              onTap: () => _onListTileTap(context),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text('Settings'),
              onTap: () => _onListTileTap(context),
            ),
            new ListTile(
              leading: new Icon(Icons.help),
              title: new Text('Help & feedback'),
              onTap: () => _onListTileTap(context),
            )
          ])),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Diseases", Icons.local_hospital),
            makeDashboardItem("Community", Icons.comment),
            makeDashboardItem("Nearby", Icons.location_on),
            makeDashboardItem("Profile", FontAwesomeIcons.solidUserCircle),
            makeDashboardItem("Gallery", FontAwesomeIcons.images),
            makeDashboardItem("Register", FontAwesomeIcons.userPlus),
            makeDashboardItem("Login", FontAwesomeIcons.signInAlt),
            makeDashboardItem("Settings", Icons.settings),
            makeDashboardItem("Help", Icons.help),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.leaf), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital), title: Text('Diseases')),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), title: Text('Community')),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), title: Text('Nearby')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.green,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => {},
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class CardView extends StatelessWidget {
  final double cardSize;
  CardView(this.cardSize);

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new SizedBox.fromSize(
      size: new Size(cardSize, cardSize),
    ));
  }
}

// Drawer test pages
class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("First Page"),
      ),
      body: new Text("I belongs to First Page"),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Second Page"),
      ),
      body: new Text("I belongs to Second Page"),
    );
  }
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
                  color: Colors.green,
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
