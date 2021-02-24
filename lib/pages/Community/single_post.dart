import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SinglePost extends StatelessWidget {
  final DocumentSnapshot snapshot;

  SinglePost(this.snapshot);

  @override
  Widget build(BuildContext context) {
    final viewportConstraints = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data['post_desc']),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    //height: viewportConstraints.height,
                    constraints: BoxConstraints(
                        minHeight: viewportConstraints.height * .4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.loose,
                          child: Image.network(
                            "${snapshot.data['post_image']}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
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
                                                "${snapshot.data['profile_photoUrl']}"))),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    snapshot.data['profile_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              /*  */
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(65.0, 0.0, 16.0, 8.0),
                          child: Text(
                            snapshot.data['post_desc'],
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0.0, 16.0, 8.0),
                              child: Text(
                                "${formatTimeStamp(snapshot.data['post_updated'])}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                          child: Text(
                            "All Comments",
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /* SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
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
                                              "${post.post_comments_profile_image_id[index]}")))),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                post.post_comments_profile_name[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          Text(
                            post.post_comments_timestamp[index],
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 0.0, 16.0, 8.0),
                      child: Text(post.post_comments[index]),
                    ),
                  ],
                );
              }, childCount: post.post_comments.length , semanticIndexOffset: 2),
            ) */
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Add a Comment...'),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.paperPlane),
                onPressed: () {},
              )
            ],
          ),
        ));
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
}
