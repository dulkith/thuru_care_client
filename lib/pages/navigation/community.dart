import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:thuru_care_client/pages/Community/add_post.dart';
import 'package:thuru_care_client/pages/Community/single_post.dart';
import 'package:thuru_care_client/pages/navigation/auth.dart';
import 'package:thuru_care_client/pages/navigation/login_screen.dart';
import 'package:thuru_care_client/pages/services/cloudFirebaseServices.dart';
import 'package:thuru_care_client/widgets/layoutWidgets.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository = UserRepository.instance();
  bool isAuth = false;
  TabController _tabController;
  double appBarHeight;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    if (userRepository.status == Status.Authenticated) {
      appBarHeight = 100;
    } else {
      appBarHeight = 56;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: layoutWidgets.appBarWidget(context,
          isCommunity: true, tabController: _tabController),
      drawer: layoutWidgets.drawerWidget(context),
      body: Center(
        child: ChangeNotifierProvider(
          builder: (_) => UserRepository.instance(),
          child: Consumer(
            builder: (context, UserRepository user, _) {
              switch (user.status) {
                case Status.Uninitialized:
                case Status.Authenticating:
                  return CircularProgressIndicator();
                  break;
                case Status.Unauthenticated:
                  return notAuthenticated(context);
                  break;
                case Status.Authenticated:
                  return isAuthenticated(context);
                  break;
              }
            },
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget returnAppBar(BuildContext context) {}

  Widget _buildFloatingActionButton() {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          if (userRepository.status == Status.Authenticated) {
            return FloatingActionButton.extended(
              backgroundColor: Colors.green[500],
              foregroundColor: Colors.white,
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WritePost()))
              },
              label: Text('Write Post'),
              icon: Icon(FontAwesomeIcons.pen),
            );
          } else {
            return Container(
              width: 0.0,
              height: 0.0,
            );
          }
        },
      ),
    );
  }

  Widget notAuthenticated(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                'assets/images/community_tc.png',
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'WELCOME TO THE \nTHURUCARE COMMUNITY',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Please Sign In or Sign Up to connect with our lovely community!',
              style: TextStyle(color: Colors.green, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            color: Colors.green,
            child: Text(
              "Sign In / Sign Up",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget isAuthenticated(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[allPosts(), singleUserPosts()],
    );
  }

  Widget allPosts() {
    return FutureBuilder(
      future: firebaseDBServices.fetchAllPosts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
              child: _buildListPostView(snapshot, _handleRefreshAllPosts));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget singleUserPosts() {
    return FutureBuilder(
      future: firebaseDBServices.fetchPostsByUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
              child: _buildListPostView(snapshot, _handleRefreshUser));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildListPostView(AsyncSnapshot snapshot, Function refreshList) {
    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: refreshList,
      showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, int index) {
          DocumentSnapshot singlePost = snapshot.data[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SinglePost(singlePost)),
              );
            },
            highlightColor: Colors.greenAccent,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      snapshot.data[index]['profile_photoUrl']),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                snapshot.data[index]['profile_name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              formatTimeStamp(
                                  snapshot.data[index]['post_updated']),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blueGrey),
                            ),
                            
                            snapshot.data[index]['profile_id'] == userRepository.user.uid ?
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext bcontext) {
                                      return AlertDialog(
                                        title: Text("Post Options"),
                                        content: FlatButton(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.trashAlt),
                                              SizedBox(width: 10,),
                                              Text("Delete Post")
                                            ],
                                          ),
                                          onPressed: () async {
                                            bool isDeleted = await firebaseDBServices
                                              .removePost(snapshot
                                                  .data[index].documentID);

                                            if (isDeleted){
                                              Navigator.pop(bcontext);
                                            }      
                                          }
                                        ),
                                        
                                      );
                                    });
                              },
                            ): Container()
                          ],
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Image.network(
                      snapshot.data[index]['post_image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${snapshot.data[index]['post_desc']}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.thumbsUp,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                print(snapshot.data[index].documentID);
                                firebaseDBServices
                                    .likePost(snapshot.data[index].documentID);
                              },
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.thumbsDown,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                print(snapshot.data[index].documentID);
                                firebaseDBServices.dislikePost(
                                    snapshot.data[index].documentID);
                              },
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                        Text(
                          "${snapshot.data[index]['post_likes']} Likes  ${snapshot.data[index]['post_comments'].length - 1} Comments",
                          style: TextStyle(color: Colors.blueGrey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* Widget showSideMenu(BuildContext bcontext, String postId) {
    
  } */

  Widget communityAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      title: new Image.asset(
        'assets/title_green.png',
        height: 40,
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        ChangeNotifierProvider(
          builder: (_) => UserRepository.instance(),
          child: Consumer(
            builder: (context, UserRepository user, _) {
              switch (user.status) {
                case Status.Uninitialized:
                case Status.Unauthenticated:
                case Status.Authenticating:
                  return IconButton(
                    icon: Icon(
                      FontAwesomeIcons.userCircle,
                      size: 25,
                    ),
                    onPressed: () => {},
                  );
                case Status.Authenticated:
                  return _buildCircleAvatar(user.user);
              }
            },
          ),
        )
      ],
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Colors.blueAccent,
        unselectedLabelColor: Theme.of(context).primaryColor,
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: new BubbleTabIndicator(
          indicatorHeight: 25.0,
          indicatorColor: Theme.of(context).primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        tabs: <Widget>[
          new Tab(text: "All Posts"),
          new Tab(text: "My Posts"),
        ],
        controller: _tabController,
      ),
    );
  }

  Future<void> _handleRefreshAllPosts() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text(
              'Grabbed You the Latest Posts! Enjoy! Please do ask your doubts here by posting a picture of your defected plant leaf! Also you could just boast about your garden!'),
          backgroundColor: Colors.green,
          elevation: 0.0,
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                firebaseDBServices.fetchAllPosts();
              })));
    });
  }

  Future<void> _handleRefreshUser() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text(
              'Grabbed You your Latest Posts! Enjoy! Please do ask your doubts here by posting a picture of your defected plant leaf! Also you could just boast about your garden!'),
          backgroundColor: Colors.green,
          elevation: 0.0,
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                firebaseDBServices.fetchPostsByUser();
              })));
    });
  }

  String formatTimeStamp(String timeStamp) {
    DateTime datePosted = DateTime.parse(timeStamp);
    DateTime now = DateTime.now();
    final timeDiff = now.difference(datePosted).inSeconds;

    if (timeDiff >= 31557600) {
      final years = timeDiff / 31557600;
      if (years.round() == 1) {
        return "${years.round()} year ago";
      } else {
        return "${years.round()} years ago";
      }
    } else if (timeDiff >= 604800) {
      final weeks = timeDiff / 604800;
      if (weeks.round() == 1) {
        return "${weeks.round()} week ago";
      } else {
        return "${weeks.round()} weeks ago";
      }
    } else if (timeDiff >= 86400) {
      final days = timeDiff / 86400;
      if (days.round() == 1) {
        return "${days.round()} day ago";
      } else {
        return "${days.round()} days ago";
      }
    } else if (timeDiff >= 3600) {
      final hours = timeDiff / 3600;
      if (hours.round() == 1) {
        return "${hours.round()} hour ago";
      } else {
        return "${hours.round()} hours ago";
      }
    } else if (timeDiff >= 60) {
      final mins = timeDiff / 60;
      if (mins.round() == 1) {
        return "${mins.round()} minuite ago";
      } else {
        return "${mins.round()} minutes ago";
      }
    } else {
      final secs = timeDiff;
      if (secs.round() == 1) {
        return "${secs.round()} second ago";
      } else {
        return "${secs.round()} seconds ago";
      }
    }
  }

  Widget _buildCircleAvatar(FirebaseUser user) {
    String photourl =
        'https://firebasestorage.googleapis.com/v0/b/ulivemedia-8a6ec.appspot.com/o/user_default.png?alt=media&token=4ed7fb78-416c-420a-9238-328666fb8e37';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(500.0),
          child: Image.network(
            user.photoUrl,
            fit: BoxFit.cover,
            height: 15.0,
          ),
        ),
      ),
    );
  }
}
