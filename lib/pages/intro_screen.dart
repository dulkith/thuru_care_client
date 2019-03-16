import 'package:flutter/material.dart';
import 'package:thuru_care_client/utils/thuru_care.dart';
import 'package:thuru_care_client/utils/my_navigator.dart';
import 'package:thuru_care_client/widgets/walkthrough.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 2) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      padding: EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 4,
            child: PageView(
              children: <Widget>[
                Walkthrough(
                  title: ThuruCare.wt1,
                  content: ThuruCare.wc1,
                  imageIcon: FontAwesomeIcons.envira,
                  imagecolor: Colors.green,
                ),
                Walkthrough(
                  title: ThuruCare.wt2,
                  content: ThuruCare.wc2,
                  imageIcon: FontAwesomeIcons.camera,
                  imagecolor: Colors.red[400],
                ),
                Walkthrough(
                  title: ThuruCare.wt3,
                  content: ThuruCare.wc3,
                  imageIcon: FontAwesomeIcons.medkit,
                  imagecolor: Colors.blueAccent,
                ),
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(lastPage ? "" : ThuruCare.skip,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () =>
                      lastPage ? null : MyNavigator.goToHome(context),
                ),
                FlatButton(
                  child: Text(lastPage ? ThuruCare.gotIt : ThuruCare.next,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  onPressed: () => lastPage
                      ? MyNavigator.goToHome(context)
                      : controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
