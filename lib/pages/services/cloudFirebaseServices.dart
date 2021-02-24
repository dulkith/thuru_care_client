import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';

class FirebaseDBServices with ChangeNotifier {
  Firestore db = Firestore.instance;
  bool _isUploaded = false;
  String _downloadURL;
  String _downloadURLProfile;
  bool _isLoading = false;
  UserRepository userRepository = UserRepository.instance();
  DocumentReference docref;
  String postId;
  List _userDataList = List();

  bool get isUploaded => _isUploaded;
  String get downloadURL => _downloadURL;
  String get downloadURLProfile => _downloadURLProfile;
  bool get isLoading => _isLoading;
  List get userDataList => _userDataList;

  Future<bool> addNewPostToDB(Map<String, dynamic> postData) async {
    try {
      docref = await db.collection('posts').add(postData);
      postId = docref.documentID;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addPostToUser(String userId, String postId) async {
    List<String> postList = new List();
    postList.add(postId);
    try {
      DocumentReference ref = db.collection('users').document(userId);
      ref.setData({'posts': FieldValue.arrayUnion(postList)}, merge: true);

      return true;
    } catch (e) {
      print(e);
    }
  }

  Future uploadImage(File image) async {
    int min = 100000;
    int max = 999999;
    Random random = new Random();
    int fn = min + random.nextInt(max - min);
    String filename = fn.toString();
    String userId = userRepository.user.uid;
    StorageReference reference =
        FirebaseStorage.instance.ref().child('posts/${userId}/${filename}.jpg');
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadAddress = await reference.getDownloadURL();
    if (downloadAddress.trim().isNotEmpty) {
      _isUploaded = true;
      notifyListeners();
      _downloadURL = downloadAddress;
      notifyListeners();
    } else {
      _isUploaded = false;
      notifyListeners();
    }
  }

  Future uploadImageProfile(File image) async {
    int min = 100000;
    int max = 999999;
    Random random = new Random();
    int fn = min + random.nextInt(max - min);
    String filename = fn.toString();
    String userId = userRepository.user.uid;
    StorageReference reference =
        FirebaseStorage.instance.ref().child('users/${userId}/${filename}.jpg');
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadAddress = await reference.getDownloadURL();
    if (downloadAddress.trim().isNotEmpty) {
      _isUploaded = true;
      notifyListeners();
      _downloadURLProfile = downloadAddress;
      notifyListeners();
    } else {
      _isUploaded = false;
      notifyListeners();
    }
  }

  Future<bool> addPost(
      File image, BuildContext context, String post_desc) async {
    _isLoading = true;
    notifyListeners();
    await uploadImage(image);
    if (image != null && isUploaded == false) {
      print("Upload Failed");
      _isLoading = false;
      notifyListeners();
      return false;
    }

    //Set Date for Upload
    DateTime now = DateTime.now();
    var dateFormatter = DateFormat('dd-MM-yyyy');
    var timeFormatter = DateFormat('h:mm a');
    String datePosted = dateFormatter.format(now);
    String timePosted = timeFormatter.format(now);
    String updatedTimeStamp = now.toString();
    Map<String, dynamic> post_new = new HashMap();
    String userId = userRepository.user.uid;

    DocumentSnapshot userSnapshot =
        await db.collection('users').document(userId).get();
    String userDisplayName = userSnapshot.data['displayName'];
    String userPhotoUrl = userSnapshot.data['photoURL'];
    print("Upload done and URL is ${downloadURL}");

    //setVariables();

    post_new = {
      "profile_id": "${userId}",
      "profile_name": "${userDisplayName}",
      "profile_photoUrl": "${userPhotoUrl}",
      "post_image": "${downloadURL}",
      "post_desc": "${post_desc}",
      "post_likes": 0,
      "post_liked_User": [],
      "post_date": "${datePosted}",
      "post_time": "${timePosted}",
      "post_updated": "${updatedTimeStamp}",
      "post_comments": [""],
      "post_comments_profile_name": [""],
      "post_comments_profile_image_id": [""],
      "post_comments_timestamp": [""]
    };

    bool isPosted = await addNewPostToDB(post_new);

    bool isPostAddedtoUser = await addPostToUser(userId, postId);

    if (!isPostAddedtoUser) {
      print("not added to userId");
    }

    if (isPosted) {
      print("Written to DB");
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      print("NotWritten to DB");
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future fetchAllPosts() async {
    _isLoading = true;
    notifyListeners();
    //List list = new List();
    try {
      QuerySnapshot querySnapshot = await db
          .collection("posts")
          .orderBy('post_updated', descending: true)
          .getDocuments();

      //QuerySnapshot userSnapshot = await db.collection('users').getDocuments();
      var list = querySnapshot.documents;
      //list.add(querySnapshot.documents);

      print("List has ${list.length} documents");
      _isLoading = false;
      notifyListeners();
      return list;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  Future fetchPostsByUser() async {
    _isLoading = true;
    notifyListeners();
    //List list = new List();
    try {
      QuerySnapshot querySnapshot = await db
          .collection("posts")
          .where("profile_id", isEqualTo: userRepository.user.uid)
          .getDocuments();

      //QuerySnapshot userSnapshot = await db.collection('users').getDocuments();
      var list = querySnapshot.documents;
      //list.add(querySnapshot.documents);

      print("List has ${list.length} documents");
      _isLoading = false;
      notifyListeners();
      return list;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  Future /* <Map<String, dynamic>> */ getUser(String uid) async {
    DocumentSnapshot userSnapshot =
        await db.collection('users').document(uid).get();

    /* var userData = {
      "displayName": userSnapshot.data['displayName'],
      "photoURL": userSnapshot.data['photoURL'],
    }; */

    List userData = List();
    userData.add(userSnapshot.data["displayName"]);
    userData.add(userSnapshot.data["photoURL"]);

    _userDataList = userData;
    return userData;
  }

  Future getAllUsers() async {
    _isLoading = true;
    notifyListeners();
    List list = new List();
    try {
      QuerySnapshot querySnapshot = await db.collection("users").getDocuments();

      //QuerySnapshot userSnapshot = await db.collection('users').getDocuments();
      //var list = querySnapshot.documents;
      list.add(querySnapshot.documents);

      print("List has ${list.length} documents");
      _isLoading = false;
      notifyListeners();
      return list;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<DocumentSnapshot> getSingleUser() async {
    try {
      DocumentSnapshot userSnapshot =
          await db.collection('users').document(userRepository.user.uid).get();

      return userSnapshot;
    } catch (e) {
      print(e);
    }
  }

  void likePost(String postId) {
    DocumentReference ref = db.collection('posts').document(postId);
    final TransactionHandler transactionHandler = (Transaction tran) async {
      DocumentSnapshot post =
          await db.collection('posts').document(postId).get();
      List usersLiked = post.data['post_liked_User'] ?? List();
      for (int i = 0; i < usersLiked.length; i++) {
        if (usersLiked[i] == userRepository.user.uid) {
          return;
        }
      }
      await tran.get(ref).then((DocumentSnapshot snap) {
        if (snap.exists) {
          tran.update(ref, <String, dynamic>{
            'post_likes': snap.data['post_likes'] + 1,
            'post_liked_User': FieldValue.arrayUnion([userRepository.user.uid])
          });
        }
      });
    };
    Firestore.instance.runTransaction(transactionHandler);
  }

  void dislikePost(String postId) {
    DocumentReference ref = db.collection('posts').document(postId);
    final TransactionHandler transactionHandler = (Transaction tran) async {
      DocumentSnapshot post =
          await db.collection('posts').document(postId).get();

      List usersLiked = post.data['post_liked_User'] ?? List();
      for (int i = 0; i < usersLiked.length; i++) {
        if (usersLiked[i] == userRepository.user.uid) {
          await tran.get(ref).then(
            (DocumentSnapshot snap) {
              if (snap.exists) {
                tran.update(ref, <String, dynamic>{
                  'post_likes': snap.data['post_likes'] - 1,
                  'post_liked_User':
                      FieldValue.arrayRemove([userRepository.user.uid])
                });
              }
            },
          );
          return;
        }
      }
    };
    Firestore.instance.runTransaction(transactionHandler);
  }

  Future<bool> removePost(String postId) async {
    try {
      DocumentReference ref = db.collection('posts').document(postId);
      final TransactionHandler transactionHandler = (Transaction tran) async {
        DocumentSnapshot post =
            await db.collection('posts').document(postId).get();

        await tran.get(ref).then((DocumentSnapshot snap) {
          if (snap.exists) {
            tran.delete(ref);
          }
        });
      };
      Firestore.instance.runTransaction(transactionHandler);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfile(
      String name, String country, String gardenLoc, bool isLocationEnabled,
      {File image}) async {
    try {
      _isLoading = true;
      notifyListeners();
      if (image != null) {
        await uploadImageProfile(image);
        if (image != null && isUploaded == false) {
          print("Upload Failed");
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      print('isLocationEnabled ${isLocationEnabled}');

      DocumentReference ref =
          db.collection('users').document(userRepository.user.uid);
      final TransactionHandler transactionHandler = (Transaction tran) async {
        DocumentSnapshot post = await db
            .collection('users')
            .document(userRepository.user.uid)
            .get();

        await tran.get(ref).then(
          (DocumentSnapshot snap) {
            if (snap.exists) {
              FirebaseAuth.instance.currentUser().then((val) {
                UserUpdateInfo updateUser = UserUpdateInfo();
                updateUser.displayName = name;
                updateUser.photoUrl =
                    _downloadURLProfile ?? post.data['photoURL'];
                val.updateProfile(updateUser);
              });

              tran.update(ref, <String, dynamic>{
                'displayName': name,
                'country': country,
                'garden_location': gardenLoc,
                'photoURL': _downloadURLProfile ?? post.data['photoURL'],
                'isGardenLocShared': isLocationEnabled,
                'last_Updated': DateTime.now()
              });
            }
          },
        );
      };
      Firestore.instance.runTransaction(transactionHandler);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

FirebaseDBServices firebaseDBServices = FirebaseDBServices();
