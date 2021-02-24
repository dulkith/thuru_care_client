import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuru_care_client/utils/intro/dots_indicator.dart';
import 'package:thuru_care_client/utils/intro/page1.dart';
import 'package:thuru_care_client/utils/intro/page2.dart';
import 'package:thuru_care_client/utils/intro/page3.dart';
import 'package:thuru_care_client/utils/my_navigator.dart';

class _OnboardingMainPageState extends State<OnboardingMainPage> {
  final _controller = new PageController();
  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
  ];
  int page = 0;

  @override
  void initState() {
    super.initState();
    setFullscreen(false);
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = page == _pages.length - 1;
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
                onPageChanged: (int p) {
                  setState(() {
                    page = p;
                  });
                },
              ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  primary: false,
                  title: Text('Thuru Care'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        isDone ? 'DONE' : 'NEXT',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: isDone
                          ? () {
                              MyNavigator.goToHome(context);
                            }
                          : () {
                              _controller.animateToPage(page + 1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                    )
                  ],
                ),
              ),
            ),
            new Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: new SafeArea(
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new DotsIndicator(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageSelected: (int page) {
                          _controller.animateToPage(
                            page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        return new Future(() => false);
      },
    );
  }

  static setFullscreen(bool value) {
    if (value) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }
}

class OnboardingMainPage extends StatefulWidget {
  OnboardingMainPage({Key key}) : super(key: key);

  @override
  _OnboardingMainPageState createState() => new _OnboardingMainPageState();
}
