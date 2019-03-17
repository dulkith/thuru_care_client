import 'package:flutter/material.dart';

class ThirdScreenState extends StatelessWidget {
 final Color color;

 ThirdScreenState(this.color);

 @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      
      body: new Text("I belongs to Third Page"),
    );
  }
}

