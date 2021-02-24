import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:thuru_care_client/models/PostModel.dart';
import 'package:thuru_care_client/models/UserModel.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';
import 'package:thuru_care_client/pages/services/cloudFirebaseServices.dart';
import 'package:thuru_care_client/scopped-models/User.dart';
import 'package:thuru_care_client/scopped-models/User.dart';

String _profile_Name = "Chris Brown";
String _profile_id = "5";
String _profile_country = "Sri Lanka";
const String post_likes = "0";
String profile_image =
    "https://firebasestorage.googleapis.com/v0/b/thuru-care.appspot.com/o/5.jpg?alt=media&token=08db222e-31ee-49f8-ad7f-f451954578f6";
TextEditingController post_desc_tf = TextEditingController();
bool isUploaded = false;
String downloadURL;
//final FirebaseDatabase _database = FirebaseDatabase.instance;
//final DatabaseReference ref = _database.getReference('');

class WritePost extends StatefulWidget {
  //final PostModel lastPost;
  //WritePost(this.lastPost);

  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  UserRepository userRepository = UserRepository.instance();
  //static FirebaseUser user = userRepository.user;
  bool isPosting = false;

  int final_post_id;
  int final_post_image;

  String current_post_id;
  String current_post_image;

  String post_desc;
  String post_timestamp;
  List<String> post_comments = List();
  List<String> post_comments_profile_image_id = List();
  List<String> post_comments_profile_name = List();
  List<String> post_comments_timestamp = List();
  TextEditingController _postDescController = TextEditingController();

  File _image;
  PostModel post;

  Map<String, dynamic> post_new = {
    "profile_id": null,
    "profile_name": null,
    "profile_country": null,
    "profile_image": null,
    "post_image": null,
    "post_desc": null,
    "post_likes": null,
    "post_timestamp": null,
    "post_comments": null,
    "post_comments_profile_name": null,
    "post_comments_profile_image_id": null,
    "post_comments_timestamp": null
  };

  List<User> userList = [];

  void setVariables() {
    _profile_id = "${userRepository.user.uid}";
    _profile_Name = "${userRepository.user.displayName}";
    profile_image = "${userRepository.user.photoUrl}";
  }

  /* Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        elevation: 0.0,
        centerTitle: true,
        title: Text("Write New Post", style: TextStyle(color: Theme.of(context).primaryColor),),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            child: _image == null || isPosting == true
                ? IconButton(
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.grey,
                    ),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                    ),
                    onPressed: () async {
                      setState(() {
                        isPosting = true;
                      });
                      bool isPostedToDB = await firebaseDBServices.addPost(
                          _image, context, _postDescController.text);

                      if (isPostedToDB) {
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          isPosting = false;
                        });
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Something went wrong!"),
                                content: Text(
                                    'We couldnt add your post in our community! Please Try Again'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Okay"),
                                  )
                                ],
                              );
                            });
                      }
                    },
                  ),
            padding: const EdgeInsets.only(right: 10.0),
          )
        ],
      ),
      body: isPosting == true
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    ImageInput(),
                    SizedBox(
                      height: 25.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: TextField(
                        controller: _postDescController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Add Description"),
                        maxLines: 10,
                        maxLength: 500,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 500.0).then((File image) {
      setState(() {
        _image = image;
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Pick an Image to Upload",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Use Camera"),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    }),
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Use Device Storage"),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    }),
              ],
            ),
          );
        });
  }

  Widget ImageInput() {
    final color = Theme.of(context).primaryColor;
    return Column(
      children: <Widget>[
        _image == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.add_to_photos),
                    SizedBox(width: 5.0),
                    Text("Select an Image")
                  ])
            : Image.file(_image,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width * 0.95,
                alignment: Alignment.topCenter),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlineButton(
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
            onPressed: () {
              _openImagePicker(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    color: color,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    "Add Image",
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
