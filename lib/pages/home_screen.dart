import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thuru_care_client/pages/navigation/community.dart';
import 'package:thuru_care_client/pages/navigation/diseases_library.dart';
import 'package:thuru_care_client/pages/navigation/login_screen.dart';
import 'package:thuru_care_client/pages/navigation/dashboard_screen.dart';
import 'package:thuru_care_client/pages/navigation/near_by_gardern.dart';
import 'package:thuru_care_client/pages/navigation/profile.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:thuru_care_client/scopped-models/User.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

class HomeScreen extends StatefulWidget {
  final Widget child;
  int initialPage;

  HomeScreen({this.child, @required this.initialPage});
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animCtrl;
  Animation<double> animation;
  TabController tabController;
  AnimationController animCtrl2;
  Animation<double> animation2;
  static UserModel usrmodel = new UserModel();

  bool showFirst = true;

  int _currentIndex = 0;
  final List<Widget> _children = [
    new FirstScreenState(),
    new DiseasesLibrary(),
    new CommunityPage(),
    new FourthScreenState(),
    new ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5, initialIndex: widget.initialPage);
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
    tabController.dispose();
    _nextPage(widget.initialPage);
    super.dispose();
  }

  void _nextPage(int tab) {
    final int newTab = tabController.index + tab;
    if (newTab < 0 || newTab >= tabController.length) return;
    tabController.animateTo(newTab);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            new FirstScreenState(),
            new DiseasesLibrary(),
            new CommunityPage(),
            new FourthScreenState(),
            new ProfilePage()
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor:Theme.of(context).primaryColor ,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(fontSize: 10),
          unselectedLabelStyle: TextStyle(fontSize: 10,),
          indicatorWeight: 4.0,
          tabs: <Widget>[
            Tab(icon: Icon(ThuruCareIcons.home), text: ThuruCare.dashHome),
            Tab(icon: Icon(ThuruCareIcons.leaf), text: ThuruCare.dashDiseases),
            Tab(icon: Icon(ThuruCareIcons.graduation_cap),text: ThuruCare.dashComm),
            Tab(icon: Icon(ThuruCareIcons.location), text: ThuruCare.dashNear),
            Tab(icon: Icon(ThuruCareIcons.user), text: ThuruCare.dashPro),
          ],
        ),
      ),
      onWillPop: () {
        return new Future(() => false);
      },
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
