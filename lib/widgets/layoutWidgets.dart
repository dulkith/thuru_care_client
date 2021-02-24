import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';
import 'package:thuru_care_client/pages/navigation/login_screen.dart';
import 'package:thuru_care_client/pages/navigation/sixth_screen.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

class LayoutWidgets {
  Widget appBarWidget(BuildContext context, {bool isCommunity, TabController tabController}) {
    return AppBar(
      centerTitle: true,
      title: new Image.asset(
        'assets/title_green.png',
        height: 40,
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: new IconThemeData(color: Colors.green),
      actions: <Widget>[
        ChangeNotifierProvider(
            builder: (_) => UserRepository.instance(),
            child: Consumer(
              builder: (context, UserRepository user, _) {
                switch (user.status) {
                  case Status.Uninitialized:
                  case Status.Unauthenticated:
                  case Status.Authenticating:
                    return IconButton(
                      icon: Icon(FontAwesomeIcons.userCircle,
                          size: 25,),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomeScreen(initialPage: 4,)));
                      },
                    );
                  case Status.Authenticated:
                    return _buildCircleAvatar(user.user);
                }
              },
            ),
          )
      ],
      bottom: isCommunity == null || isCommunity == false ? PreferredSize(preferredSize: Size(0.0, 0.0), child: Container(width: 0.0, height: 0.0,),) : TabBar(
        isScrollable: true,
        indicatorColor: Colors.blueAccent,
        unselectedLabelColor: Theme.of(context).primaryColor,
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: new BubbleTabIndicator(
          indicatorHeight: 25.0,
          indicatorColor: Theme.of(context).primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        tabs: <Widget>[
          new Tab(text: "All Posts"),
          new Tab(text: "My Posts"),
        ],
        controller: tabController,
      ),
    );
  }

  Widget drawerWidget(BuildContext context) {
    
    return Drawer(
      elevation: 0.0,
        child: new ListView(
            padding: const EdgeInsets.only(top: 0.0),
            children: <Widget>[
          ChangeNotifierProvider(
            builder: (_) => UserRepository.instance(),
            child: Consumer(
              builder: (context, UserRepository user, _) {
                switch (user.status) {
                  case Status.Authenticated:
                    //user.user.reload();
                    return userAccountWidget(user.user, context);
                    break;
                  case Status.Authenticating:
                    return CircularProgressIndicator();
                    break;
                  case Status.Unauthenticated:
                  case Status.Uninitialized:
                    return userAccountNotAvailable(context);
                    break;
                  default:
                    return userAccountNotAvailable(context);
                }
              },
            ),
          ),
          new ListTile(
            leading: new Icon(ThuruCareIcons.home, size: 20),
            title: new Text(ThuruCare.drawerHome),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(initialPage: 0,)));
            },
          ),
          new ListTile(
            leading: new Icon(ThuruCareIcons.leaf, size: 20),
            title: new Text(ThuruCare.drawerDiseasesDiag),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraHomeScreen()));
            },
          ),
          new ListTile(
            leading: new Icon(ThuruCareIcons.graduation_cap, size: 20),
            title: new Text(ThuruCare.drawerComSupport),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(initialPage: 2,)));
            },
          ),
          new ListTile(
            leading: new Icon(ThuruCareIcons.location, size: 20),
            title: new Text(ThuruCare.drawerNearGarden),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(initialPage: 3,)));
            },
          ),
          new Divider(),
          
          new ListTile(
            leading: new Icon(FontAwesomeIcons.cog, size:20),
            title: new Text(ThuruCare.drawerSettings),
            onTap: () => _onListTileTap(context),
          ),
          new ListTile(
            leading: new Icon(FontAwesomeIcons.penAlt, size: 20,),
            title: new Text(ThuruCare.drawerHelpAndFeed),
            onTap: () => _onListTileTap(context),
          )
        ]));
  }

  Widget userAccountWidget(FirebaseUser user, BuildContext context) {
    String photoUrlAlt =
        "https://firebasestorage.googleapis.com/v0/b/thuru-care.appspot.com/o/users%2Fuser_icon.png?alt=media&token=bb55070d-646a-40a6-b520-23486afacfba";
    
    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>HomeScreen(initialPage: 4,)));
      },
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          ClipRRect(
            borderRadius: new BorderRadius.circular(500.0),
            child: Image.network(
              user.photoUrl ?? photoUrlAlt,
              fit: BoxFit.cover,
              height: 60.0,
              width: 60.0,
            ),
          ),
          SizedBox(
            height: 7.0,
          ),
          Text(user.displayName ?? user.email, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
          SizedBox(
            height: 2.0,
          ),
          Text(user.email , style: TextStyle(color: Colors.blueGrey),),
          Center(
          child: FlatButton(
            onPressed: () {
              authService.signOut();  
            },
            child: Text(
              "Sign Out",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            color: Color(0xFFFB8181),
          ),
        ),
          SizedBox(
            height: 40.0,
          ),
        ],
      ),
    );
  }

  Widget userAccountNotAvailable(context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Center(
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Text(
            "Sign In | Sign Up",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ),
      ),
    );
  }

  _onListTileTap(
    BuildContext context,
  ) {
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

  Widget _buildCircleAvatar(FirebaseUser user) {
    String photourl =
        'https://firebasestorage.googleapis.com/v0/b/ulivemedia-8a6ec.appspot.com/o/user_default.png?alt=media&token=4ed7fb78-416c-420a-9238-328666fb8e37';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(500.0),
          child: Image.network(
            user.photoUrl,
            fit: BoxFit.cover,
            height: 15.0,
          ),
        ),
      ),
    );
    
  }

}

LayoutWidgets layoutWidgets = LayoutWidgets();
