import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glob/glob.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thuru_care_client/pages/home_screen.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';
import 'package:thuru_care_client/pages/services/cloudFirebaseServices.dart';

class EditProfilePage extends StatefulWidget {
  bool isSwitched = false;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserRepository userRepository = UserRepository.instance();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<DocumentSnapshot> future;
  bool isUpdatingProfile = false;

  @override
  void initState() {
    future = firebaseDBServices.getSingleUser();
    super.initState();
  }

  void _updateProfileFormValidator(Function updateProfile, String name,
      String country, String gardenLoc, bool isLocationEnabled,
      {File image}) async {
    if (!_formKey.currentState.validate()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Something is not Right!"),
              content: Text("One or more fields are empty"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      return;
    }

    setState(() {
      isUpdatingProfile = true;
    });

    bool isProfileUpdated =
        await updateProfile(name, country, gardenLoc, isLocationEnabled);
    if (isProfileUpdated) {
      Navigator.pop(context);
    } else {
      setState(() {
        isUpdatingProfile = true;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed to Update Profile"),
              content: Text(
                  "This could be due to a Network Error or the Email deosnt exist in our database. Please try again"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //_nameController.text = widget.user.displayName;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            initialPage: 4,
                          )));
            },
          ),
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              String displayName = snapshot.data['displayName'] ?? "";
              String country = snapshot.data['country'] ?? "";
              String location = snapshot.data['garden_location'] ?? "";
              widget.isSwitched = snapshot.data['isGardenLocShared'] ?? true;
              String photoURL = snapshot.data['photoURL'];

              _nameController.value =
                  _nameController.value.copyWith(text: displayName);
              _countryController.value =
                  _countryController.value.copyWith(text: country);
              _locationController.value =
                  _locationController.value.copyWith(text: location);

                  

              String displayNameOnsavedVal;
              String countryOnsavedVal;
              String locationOnsavedVal;

              return ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Center(
                        child: isUpdatingProfile == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(500.0),
                                    child: Image.network(
                                      photoURL,
                                      fit: BoxFit.cover,
                                      height: 80.0,
                                      width: 80.0,
                                    ),
                                  ),
                                  ButtonBar(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () {},
                                        color: Colors.green,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0)),
                                        clipBehavior: Clip.antiAlias,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              "Change Picture",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          height: 50,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5)
                                              ]),
                                          child: TextFormField(
                                            //initialValue: displayName,
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                                hintText: "Name"),
                                            validator: (String value) {
                                              if (value.isEmpty ||
                                                  value.trim().length == 0) {
                                                return 'Please donot keep the fields empty';
                                              }
                                            },
                                            onSaved: (String value) {
                                              displayNameOnsavedVal = value;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          height: 50,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5)
                                              ]),
                                          child: TextFormField(
                                            //initialValue: country,
                                            controller: _countryController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                                hintText: "Country"),
                                            validator: (String value) {
                                              if (value.isEmpty ||
                                                  value.trim().length == 0) {
                                                return 'Please donot keep the fields empty';
                                              }
                                            },
                                            onSaved: (String value) {
                                              countryOnsavedVal = value;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          height: 50,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5)
                                              ]),
                                          child: TextFormField(
                                            //initialValue: location,
                                            controller: _locationController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                icon: Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                ),
                                                hintText: "Garden Loacation"),
                                            validator: (String value) {
                                              if (value.isEmpty ||
                                                  value.trim().length == 0) {
                                                return 'Please donot keep the fields empty';
                                              }
                                            },
                                            onSaved: (String value) {
                                              locationOnsavedVal = value;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Share Garden Location"),
                                              Switch(
                                                value: widget.isSwitched,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    widget.isSwitched = value;
                                                    print(
                                                        'At Switch ${widget.isSwitched}');
                                                  });
                                                },
                                                activeTrackColor: Colors.green,
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        _buildButton(
                                            context,
                                            displayNameOnsavedVal,
                                            countryOnsavedVal,
                                            locationOnsavedVal)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ],
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget _buildButton(BuildContext context, String displayName, String country,
      String location) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.3,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.lightGreen,
            Colors.green,
          ]),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: new Material(
        child: MaterialButton(
          child: Text(
            'UPDATE PROFILE',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
          ),
          onPressed: () {
            print('isSwitched ${widget.isSwitched}');
            _updateProfileFormValidator(firebaseDBServices.updateProfile,
                displayName, country, location, widget.isSwitched);
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }
}
