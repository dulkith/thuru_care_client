import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordControllerconfirm = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPasswordReset = GlobalKey<FormState>();
  bool isSignInRegister = false;

  UserRepository userRepository = UserRepository.instance();

  AuthMode authMode = AuthMode.Login;

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'name': null
  };

  void _passwordResetFormValidator(Function pwReset, String email) async {
    if (!_formKeyPasswordReset.currentState.validate()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Something is not Right!"),
              content: Text(
                  "Fields are not Correctly filled. There maybe some issue with the data provided. Please check again"),
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

    bool isResetSent = await pwReset(email);
    if (isResetSent) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Reset Link Sent"),
              content: Text(
                  "We emailed you a password reset link to the mentioned email. Please follow the instructions there"),
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
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed to Send Reset"),
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

  void _submitForm(Function signIn, Function register) async {
    if (!_formKey.currentState.validate()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Something is not Right!"),
              content: Text(
                  "Fields are not Correctly filled. There maybe some issue with the data provided. Please check again"),
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

    if (authMode == AuthMode.Login) {
      setState(() {
        isSignInRegister = true;
      });
      bool isSignedIn =
          await signIn(_emailController.text.trim(), _passwordController.text);
      if (isSignedIn) {
        Navigator.pop(context);
      } else {
        setState(() {
          isSignInRegister = false;
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Login Failed"),
                content: Text(
                    "We failed to Log you In. Check your connection! This is could also be because of an incorrect Email or Password!"),
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
    } else {
      setState(() {
        isSignInRegister = true;
      });

      bool isRegistered = await register(_emailController.text.trim(),
          _nameController.text, _passwordController.text);
      if (isRegistered) {
        Navigator.pop(context);
      } else {
        setState(() {
          isSignInRegister = false;
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Registration Failed"),
                content: Text(
                    "We failed to Register you! This could be because of a connection error."),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          authMode == AuthMode.Login ? "Sign In" : "Sign Up",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: isSignInRegister == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new ListView(
              children: <Widget>[
                Image.asset(
                  authMode == AuthMode.Login
                      ? 'assets/images/login.png'
                      : 'assets/images/register.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(
                  height: 0.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      authMode == AuthMode.Register
                          ? Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: 50,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 5)
                                  ]),
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    hintText: "Name"),
                                // validator: validateName,
                              ),
                            )
                          : Container(
                              height: 0.0,
                              width: 0.0,
                            ),
                      Container(
                        padding: EdgeInsets.only(top: 32),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: 50,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 5)
                                  ]),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (String value) {
                                  if (value.isEmpty ||
                                      !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                          .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    hintText: "Email"),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              height: 50,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 5)
                                  ]),
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (String value) {
                                  if (value.isEmpty || value.length < 6) {
                                    return 'Password invalid';
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.grey,
                                    ),
                                    hintText: "Password"),
                              ),
                            ),
                            authMode == AuthMode.Register
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    height: 50,
                                    margin: EdgeInsets.only(top: 20),
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
                                      controller: _passwordControllerconfirm,
                                      obscureText: true,
                                      validator: (String value) {
                                        if (value != _passwordController.text) {
                                          return 'Please confirm your password';
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.done_all,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Confirm Password"),
                                    ),
                                  )
                                : Container(
                                    width: 0.0,
                                    height: 0.0,
                                  ),
                            authMode == AuthMode.Register
                                ? Container()
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 40, bottom: 0),
                                        child: FlatButton(
                                          child: Text(
                                            "Forgot Password ?",
                                            style: TextStyle(
                                                color: Colors.black38,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          onPressed: () {
                                            TextEditingController
                                                _passwordResetController =
                                                TextEditingController();
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Reset Password"),
                                                    content: Form(
                                                      key:
                                                          _formKeyPasswordReset,
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.3,
                                                        height: 50,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  blurRadius: 5)
                                                            ]),
                                                        child: TextFormField(
                                                          controller:
                                                              _passwordResetController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          validator:
                                                              (String value) {
                                                            if (value.isEmpty ||
                                                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                                    .hasMatch(
                                                                        value)) {
                                                              return 'Please enter a valid email';
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  icon: Icon(
                                                                    Icons.email,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  hintText:
                                                                      "Email"),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text(
                                                            'ResetPassword'),
                                                        onPressed: () {
                                                          _passwordResetFormValidator(
                                                              userRepository
                                                                  .passwordReset,
                                                              _passwordResetController
                                                                  .text);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                        )),
                                  ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: <Widget>[
                                _buildButton(context),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                    border: Border.all(
                                        color: Colors.green, width: 1.0),
                                    color: Colors.transparent,
                                  ),
                                  child: new Material(
                                    child: MaterialButton(
                                      child: Text(
                                        authMode == AuthMode.Login
                                            ? 'SIGN UP'
                                            : 'SIGN IN',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(color: Colors.green),
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          authMode == AuthMode.Login
                                              ? authMode = AuthMode.Register
                                              : authMode = AuthMode.Login;
                                        })
                                      },
                                      highlightColor: Colors.white30,
                                      splashColor: Colors.white30,
                                    ),
                                    color: Colors.transparent,
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _buildGoogleSignInButton(context)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildButton(BuildContext context) {
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
            authMode == AuthMode.Login ? 'SIGN IN' : 'SIGN UP',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
          ),
          onPressed: () {
            _submitForm(userRepository.signIn, userRepository.register);
          },
          highlightColor: Colors.white30,
          splashColor: Colors.white30,
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.3,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(30.0),
        border: Border.all(color: Colors.red, width: 1.0),
        color: Colors.transparent,
      ),
      child: new Material(
        child: MaterialButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              Text(
                "SIGN IN WITH GOOGLE",
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            ],
          ),
          onPressed: () async {

            bool isGoogleSignedIn = await userRepository.googleSignIn();
            if (isGoogleSignedIn) {
              Navigator.of(context).pop();
            } else {

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Google SignIn Failed"),
                      content: Text(
                          "Something wrong with the Google Sign In process. Please do try again!"),
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
