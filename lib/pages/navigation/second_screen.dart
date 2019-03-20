import 'package:flutter/material.dart';

class SecondScreenState extends StatelessWidget {
  final Color color;

  SecondScreenState(this.color);

  @override
  Widget build(BuildContext ctxt) {
    return new Scaffold(
      body: new Text("I belongs to Second Page"),
    );
  }
}
