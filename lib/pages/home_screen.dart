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

class HomeScreen extends StatefulWidget {
  var cameras;
  HomeScreen();

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
   new FirstScreenState(),
   new SecondScreenState(Colors.yellow),
   new ThirdScreenState(Colors.green),
   new FourthScreenState(Colors.black),
   new FifthScreenState()
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
          MaterialPageRoute(builder: (context) => new CameraHomeScreen()),
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
