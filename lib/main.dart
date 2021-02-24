/*
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:thuru_care_client/pages/navigation/fifth_screen.dart';
import 'package:thuru_care_client/pages/navigation/login_screen.dart';
import 'package:thuru_care_client/pages/navigation/register_screen.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

void main() => runApp(new MyApp());

const String page1 = "Page 1";
const String page2 = "Page 2";
const String page3 = "Page 3";
const String title = "BNB Demo";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      home: new MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages;
  Widget _page1;
  Widget _page2;
  Widget _page3;
  Widget _page4;
  Widget _page5;

  int _currentIndex;
  Widget _currentPage;

  @override
  void initState() {
    super.initState();

    _page1 = Page1();
    _page2 = LoginPage();
    _page3 = RegisterPage();
    _page4 = Page2();
    _page5 = Page3();

    _pages = [_page1, _page2, _page3, _page4, _page5];

    _currentIndex = 0;
    _currentPage = _page1;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _currentPage,

      bottomNavigationBar: GradientBottomNavigationBar(
          backgroundColorStart: Colors.green,
          backgroundColorEnd: Colors.lightGreen,
          onTap: (index) => changeTab(index),
          currentIndex: _currentIndex,
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
        ],),

      drawer: new Drawer(
        child: new Container(
          margin: EdgeInsets.only(top: 20.0),
          child: new Column(
            children: <Widget>[
              navigationItemListTitle(page1, 0),
              navigationItemListTitle(page2, 1),
              navigationItemListTitle(page3, 2),
              navigationItemListTitle(title, 3),
              navigationItemListTitle(title, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationItemListTitle(String title, int index) {
    return new ListTile(
      title: new Text(
        title,
        style: new TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        changeTab(index);
      },
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RegisterPage(),
              )),
        child: const Text('Enabled Button'),
      ),

    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(page2),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(page3),
    );
  }
}
*/

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/intro_screen.dart';
import 'package:thuru_care_client/pages/splash_screen.dart';

Future<Null> main() async {
  runApp(new MyApp());
}

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(initialPage: 0,),
  "/intro": (BuildContext context) => OnboardingMainPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
            primaryColor: Color(0xFF037A1B),
            accentColor: Colors.greenAccent,
            fontFamily: 'Ubuntu',
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.white
            ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: routes);
  }
}
