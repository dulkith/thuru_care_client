import "package:flutter/material.dart";

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new GradientAppBar("Custom Gradient App Bar"),
        new Container()
      ],
    );
  }
}

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 60.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Row(
        children: <Widget>[
          Container(
            child: new IconButton(
              icon: new IconTheme(
                data: new IconThemeData(color: Colors.white),
                child: new Icon(Icons.menu),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          new Expanded(
            child: Container(
              child: new Image.asset(
                'assets/title.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            child: new IconButton(
              icon: new IconTheme(
                data: new IconThemeData(color: Colors.white),
                child: new Icon(Icons.search),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [Colors.green, Colors.lightGreen],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
