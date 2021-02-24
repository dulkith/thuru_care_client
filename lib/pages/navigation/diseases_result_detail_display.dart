import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuru_care_client/models/DiseaseModel.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';
import 'package:http/http.dart' as http;

class ResultDetailPage extends StatelessWidget {
  final String diseaseKey;

  ResultDetailPage(this.diseaseKey);

  @override
  Widget build(BuildContext context) {
    return ResultDetailPageState(diseaseKey);
  }
}

class ResultDetailPageState extends StatelessWidget {
  final String diseaseKey;

  ResultDetailPageState(this.diseaseKey);

  //DiseaseModel disease;

  Future<DiseaseModel> fetchDisease() async {
    final response = await http
        .get('http://35.247.186.2:9000/get_disease_by_key?key=$diseaseKey');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var result = json.decode(response.body);
      DiseaseModel model = DiseaseModel.fromJson(result);
      print(model.name);
      return model;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load disease');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.green),
    );

    return new Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                FutureBuilder<DiseaseModel>(
                  future: fetchDisease(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DiseaseModel disease = snapshot.data;

                      return new Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          "http://35.247.186.2:9000/static/" +
                                              disease.imageTitle),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                padding: EdgeInsets.all(40.0),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 100.0),
                                      Icon(
                                        ThuruCareIcons.plant,
                                        color: Colors.white,
                                        size: 40.0,
                                      ),
                                      Container(
                                        width: 500.0,
                                        child: new Divider(color: Colors.green),
                                      ),
                                      SizedBox(height: 5.0),
                                      Text(
                                        disease.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                      SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.insect,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible:
                                                disease.category == "Insect",
                                          ),
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.fungus,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible:
                                                disease.category == "Fungus",
                                          ),
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.bacteria,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible:
                                                disease.category == "Bacteria",
                                          ),
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.virus,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible:
                                                disease.category == "Virus",
                                          ),
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.deficiency,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible: disease.category ==
                                                "Deficiency",
                                          ),
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.mite,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible: disease.category == "Mite",
                                          ),
                                          Visibility(
                                            child: new Icon(
                                              ThuruCareIcons.beaker,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            visible:
                                                disease.category == "Other",
                                          ),
                                          Text(
                                            " " + disease.category,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 8.0,
                                top: 12.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20.0),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Synonyms  ",
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          disease.synonyms,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Definition",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "    " + disease.definition,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Symptoms",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "    " + disease.symptoms,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Trigger",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "    " + disease.trigger,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "PriventiveMesures",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "• " + disease.priventiveMesures[0],
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Text(
                                    "• " + disease.priventiveMesures[1],
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),

                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Biological Control",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "    " + disease.biologicalControl,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Chemical Control",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "    " + disease.chemicalControl,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 10.0),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Traditional Control",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    "    " + disease.traditionalControl,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 6.0),

                                  //readButton
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner
                    return Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: new CircularProgressIndicator(
                              valueColor:
                                  new AlwaysStoppedAnimation(Colors.green[800]),
                              strokeWidth: 5.0),
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
