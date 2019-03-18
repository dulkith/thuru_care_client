import 'package:flutter/material.dart';
import 'package:thuru_care_client/pages/navigation/fifth_screen.dart';
import 'package:thuru_care_client/pages/navigation/first_screen.dart';
import 'package:thuru_care_client/pages/navigation/fourth_screen.dart';
import 'package:thuru_care_client/pages/navigation/second_screen.dart';
import 'package:thuru_care_client/pages/navigation/sixth_screen.dart';
import 'package:thuru_care_client/pages/navigation/third_screen.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';

const String _AccountName = 'Dulkith Bataduwa';
const String _AccountEmail = 'dulkith.2016210@iit.ac.lk';
const String _AccountAbbr = 'D';

class HomeScreen extends StatefulWidget {
  var cameras;
  HomeScreen(this.cameras);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animCtrl;
  Animation<double> animation;

  AnimationController animCtrl2;
  Animation<double> animation2;

  bool showFirst = true;

  int _currentIndex = 0;
 final List<Widget> _children = [
   FirstScreenState(Colors.red),
   SecondScreenState(Colors.deepOrange),
   ThirdScreenState(Colors.green),
   FourthScreenState(Colors.black),
   FifthScreenState(Colors.yellow)
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
      body: _children[_currentIndex],
      bottomNavigationBar: GradientBottomNavigationBar(
        backgroundColorStart: Colors.green,
        backgroundColorEnd: Colors.lightGreen,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(ThuruCare.dashHome)),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.leaf), title: Text(ThuruCare.dashDiseases)),
          BottomNavigationBarItem(
              icon: Icon(Icons.comment), title: Text(ThuruCare.dashComm)),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), title: Text(ThuruCare.dashNear)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text(ThuruCare.dashPro)),
        ],
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => new CameraScreen(widget.cameras)),
        )
        },
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
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
