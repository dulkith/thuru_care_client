import 'package:thuru_care_client/utils/intro/circles_with_image.dart';
import 'package:thuru_care_client/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';

const double IMAGE_SIZE = 300.0;

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: double.infinity,
      width: double.infinity,
      decoration: new BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.pink[400],
                Colors.deepPurple[600],
                Colors.deepPurple[900],
              ],
              begin: Alignment(0.5, -1.0),
              end: Alignment(0.5, 1.0)
          )
      ),
      child: Stack(
        children: <Widget>[
          new Positioned(
            child: new CircleWithImage(Assets.pose2),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          new Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Image(
                    image: AssetImage(Assets.pose2),
                    fit: BoxFit.fitHeight,
                  ),
                  height: IMAGE_SIZE,
                  width: IMAGE_SIZE,
                ),
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(ThuruCare.wt2,
                    style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(ThuruCare.wc2,
                  style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        ],
        alignment: FractionalOffset.center,
      ),
    );
  }
}