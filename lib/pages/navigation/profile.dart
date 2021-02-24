import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thuru_care_client/models/UserModel.dart';
import 'package:thuru_care_client/pages/Profile/edit_profile.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';
import 'package:thuru_care_client/pages/navigation/login_screen.dart';
import 'package:thuru_care_client/pages/services/cloudFirebaseServices.dart';
import 'package:thuru_care_client/scopped-models/User.dart';
import 'package:http/http.dart' as http;
import 'package:thuru_care_client/widgets/layoutWidgets.dart';

class ProfilePage extends StatelessWidget {
  UserRepository userRepository = UserRepository.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: layoutWidgets.appBarWidget(context),
      drawer: layoutWidgets.drawerWidget(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ChangeNotifierProvider(
                  builder: (_) => UserRepository.instance(),
                  child: Consumer(
                    builder: (context, UserRepository user, _) {
                      switch (user.status) {
                        case Status.Authenticated:
                          return isAuthenticatedPage(context, user.user);
                          break;
                        case Status.Authenticating:
                          return CircularProgressIndicator();
                        case Status.Unauthenticated:
                        case Status.Uninitialized:
                          return notAuthenticated(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget notAuthenticated(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                'assets/images/profile.png',
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'THIS IS YOUR PROFILE AREA',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Please Sign In or Sign Up to view and Edit your amazing profile',
              style: TextStyle(color: Colors.green, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            color: Colors.green,
            child: Text(
              "Sign In / Sign Up",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget isAuthenticatedPage(BuildContext context, FirebaseUser currentUser) {
    return FutureBuilder(
      future: firebaseDBServices.getSingleUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: new BorderRadius.circular(500.0),
                        child: Image.network(
                          currentUser.photoUrl,
                          fit: BoxFit.cover,
                          height: 80.0,
                          width: 80.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
                        child: Text(
                          currentUser.displayName ?? "",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        currentUser.email ?? "",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              userRepository.signOut();
                            },
                            color: Color(0xFFFB8181),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                            clipBehavior: Clip.antiAlias,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Sign Out",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage()));
                            },
                            color: Colors.green,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                            clipBehavior: Clip.antiAlias,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.edit,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
