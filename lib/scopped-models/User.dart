import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:thuru_care_client/models/UserModel.dart';
import 'package:http/http.dart' as http;

class UserModel extends Model{
  User _authenticatedUser;

  User get authenticatedUser{
    return this._authenticatedUser;
  }

  void setauthenticatedUser(User user){
    _authenticatedUser = user;
  }

  Future<Map<String,dynamic>> login(String email, String password) async{
    final Map<String, dynamic> authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyA2DTBJLffzDRZzN01PjScpfE8cFAbCa3k', body: json.encode(authData), headers: {'Content-Type': 'application/json'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = "Something Went Wrong";
    if(responseData.containsKey('idToken')){
      hasError = false;
      message = "Authentication Succeeded";
      _authenticatedUser = User(id: responseData['localId'], email: responseData['email'], token: responseData['idToken'] );

      setauthenticatedUser(_authenticatedUser);


      
    }else if(responseData['error']['message'] == 'EMAIL_NOT_FOUND'){
      message = "This Email is not found!";
    }else if(responseData['error']['message'] == 'INVALID_PASSWORD'){
      message = "Password is Incorrect!";
    }else if(responseData['error']['message'] == 'USER_DISABLED'){
      message = "This user is disabled!";
    }

    return {'success': !hasError, 'message': message};

  }

  Future<Map<String,dynamic>> signup(String email,String password) async{
    print("Trying to sign up");
    print("Recieved Data as : email : ${email} & pw: ${password}");
    final Map<String, dynamic> authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };

    print("Created authData map ${authData['email']}");

    final http.Response response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyA2DTBJLffzDRZzN01PjScpfE8cFAbCa3k', body: json.encode(authData), headers: {'Content-Type': 'application/json'});

    print("PostRequest sent");
    print("${response.statusCode}");

    final Map<String, dynamic> responseData = json.decode(response.body);
    print("${response.body}");
    bool hasError = true;
    String message = "Something Went Wrong";
    if(responseData.containsKey('idToken')){
      print("Entered Success block");
      hasError = false;
      message = "Authentication Succeeded";
      _authenticatedUser = User(id: responseData['localId'], email: responseData['email'], token: responseData['idToken'] );

      setauthenticatedUser(_authenticatedUser);
      print("User Created as ${_authenticatedUser.id}");
    }else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      print("Entered Email Exist Block");
      message = "This Email Already Exists!";
    }

    return {'success': !hasError, 'message': message};

  }
}