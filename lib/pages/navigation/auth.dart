import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

enum AuthMode { Login, Register }

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }
enum SignInStat { EmailAuth, GoogleAuth, NoAuth }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Firestore db = Firestore.instance;
  Status _status = Status.Uninitialized;
  bool _isLoading = false;
  bool _showTab = false;
  SignInStat _signInstat = SignInStat.NoAuth;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  SignInStat get signInStat => _signInstat;
  FirebaseUser get user => _user;
  bool get isLoading => _isLoading;
  bool get showTab => _showTab;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      while (_user == null) {
        print('User is null');
      }
      updateUserData(_user);
      _signInstat = SignInStat.EmailAuth;
      notifyListeners();
      _isLoading = false;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String name, String password) async {
    _isLoading = true;
    notifyListeners();
    String picUrl =
        "https://firebasestorage.googleapis.com/v0/b/thuru-care.appspot.com/o/users%2Fuser_icon.png?alt=media&token=bb55070d-646a-40a6-b520-23486afacfba";
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseAuth.instance.currentUser().then((val) {
        UserUpdateInfo updateUser = UserUpdateInfo();
        updateUser.displayName = name;
        updateUser.photoUrl = picUrl;
        val.updateProfile(updateUser);
      });
      FirebaseUser currentUser = await _auth.currentUser();
      await currentUser.reload();
      currentUser = await _auth.currentUser();
      updateUserData(currentUser);
      _user.sendEmailVerification();
      _signInstat = SignInStat.EmailAuth;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      _isLoading = true;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> googleSignIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser firebaseuser =
          (await _auth.signInWithCredential(credential)).user;

      updateUserData(firebaseuser);
      _signInstat = SignInStat.GoogleAuth;
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    try{
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }catch(e){
      print(e);
    }
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> passwordReset(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = db.collection('users').document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
    }, merge: true);
  }
}

UserRepository authService = UserRepository.instance();
