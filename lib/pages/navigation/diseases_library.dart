import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thuru_care_client/models/DiseaseModel.dart';
import 'package:http/http.dart' as http;
import 'package:thuru_care_client/pages/navigation/diseases_detail_display.dart';
import 'package:thuru_care_client/pages/navigation/diseases_result_detail_display.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:thuru_care_client/widgets/layoutWidgets.dart';

class DiseasesLibrary extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: layoutWidgets.appBarWidget(context),
      drawer: layoutWidgets.drawerWidget(context),
      body: Center(
        child: MyHomePage(),
      ),
    );
  }
}

 class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<DiseaseModel> diseasesList = List();
  var isLoading = false;

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    var response;
    try{
      response =
        await http.get("http://35.247.186.2:9000/get_all_diseases");
    
    }catch (e){
      print(e);
    }
    if (response.statusCode == 200) {
      diseasesList = (json.decode(response.body) as List)
          .map((data) => new DiseaseModel.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Disease');
    }
  }

  initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _fetchData;
              })));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: SizedBox(
                  child: new CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(Colors.green[800]),
                      strokeWidth: 5.0),
                  height: 50.0,
                  width: 50.0,
                ),
              ),
            )
          : LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              showChildOpacityTransition: false,
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                itemCount: diseasesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      child: Image.network(
                          "http://35.247.186.2:9000/static/" +
                              diseasesList[index].imageTitle,
                          height: 65,
                          width: 90,
                          fit: BoxFit.fill),
                    ),
                    title: Text(diseasesList[index].name),
                    subtitle: Row(
                      children: <Widget>[
                        Visibility(
                          child: new Icon(ThuruCareIcons.insect, size: 18.0),
                          visible: diseasesList[index].category == "Insect",
                        ),
                        Visibility(
                          child: new Icon(ThuruCareIcons.fungus, size: 18.0),
                          visible: diseasesList[index].category == "Fungus",
                        ),
                        Visibility(
                          child: new Icon(ThuruCareIcons.bacteria, size: 18.0),
                          visible: diseasesList[index].category == "Bacteria",
                        ),
                        Visibility(
                          child: new Icon(ThuruCareIcons.virus, size: 18.0),
                          visible: diseasesList[index].category == "Virus",
                        ),
                        Visibility(
                          child:
                              new Icon(ThuruCareIcons.deficiency, size: 18.0),
                          visible: diseasesList[index].category == "Deficiency",
                        ),
                        Visibility(
                          child: new Icon(ThuruCareIcons.mite, size: 18.0),
                          visible: diseasesList[index].category == "Mite",
                        ),
                        Visibility(
                          child: new Icon(ThuruCareIcons.beaker, size: 18.0),
                          visible: diseasesList[index].category == "Other",
                        ),
                        Text(" " + diseasesList[index].category),
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(disease: diseasesList[index]),
                          //DetailPage()));
                          //ResultDetailPage(diseasesList[index].key)));
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        onPressed: () async {},
        label: Text('Filter!'),
        icon: Icon(ThuruCareIcons.a2z),
        heroTag: null,
      ),
    );
  }
}