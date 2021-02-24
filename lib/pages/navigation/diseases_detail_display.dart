import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuru_care_client/models/DiseaseModel.dart';
import 'package:thuru_care_client/presentation/thuru_care_icons_icons.dart';

class DetailPage extends StatelessWidget {
  final DiseaseModel disease;

  DetailPage({Key key, this.disease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.green));
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 50,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(1.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "\$" + disease.category.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Visibility(
              child: new Icon(
                ThuruCareIcons.insect,
                size: 20.0,
                color: Colors.white,
              ),
              visible: disease.category == "Insect",
            ),
            Visibility(
              child: new Icon(
                ThuruCareIcons.fungus,
                size: 20.0,
                color: Colors.white,
              ),
              visible: disease.category == "Fungus",
            ),
            Visibility(
              child: new Icon(
                ThuruCareIcons.bacteria,
                size: 20.0,
                color: Colors.white,
              ),
              visible: disease.category == "Bacteria",
            ),
            Visibility(
              child: new Icon(
                ThuruCareIcons.virus,
                size: 20.0,
                color: Colors.white,
              ),
              visible: disease.category == "Virus",
            ),
            Visibility(
              child: new Icon(
                ThuruCareIcons.deficiency,
                size: 20.0,
                color: Colors.white,
              ),
              visible: disease.category == "Deficiency",
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
              visible: disease.category == "Other",
            ),
            Text(
              " " + disease.category,
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ],
        ),
      ],
    );

    /* final topContent = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(
                      "http://35.247.186.2:9000/static/" +
                          disease.imageTitle),
                  fit: BoxFit.cover)),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ]
            )
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 12.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    ); */

    final topContentCategory = Row(
      children: <Widget>[
        Visibility(
          child: new Icon(
            ThuruCareIcons.insect,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Insect",
        ),
        Visibility(
          child: new Icon(
            ThuruCareIcons.fungus,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Fungus",
        ),
        Visibility(
          child: new Icon(
            ThuruCareIcons.bacteria,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Bacteria",
        ),
        Visibility(
          child: new Icon(
            ThuruCareIcons.virus,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Virus",
        ),
        Visibility(
          child: new Icon(
            ThuruCareIcons.deficiency,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Deficiency",
        ),
        Visibility(
          child: new Icon(
            ThuruCareIcons.mite,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Mite",
        ),
        Visibility(
          child: new Icon(
            ThuruCareIcons.beaker,
            size: 20.0,
            color: Colors.blueGrey,
          ),
          visible: disease.category == "Other",
        ),
        Text(
          " " + disease.category,
          style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
        )
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(
              borderRadius:
              BorderRadius.only(bottomRight: Radius.circular(50.0)),
              image: new DecorationImage(
                  image: new NetworkImage(
                      "http://35.247.186.2:9000/static/" +
                          disease.imageTitle),
                  fit: BoxFit.cover)),
        ),
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
                borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.green,
                    ]))),
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          size: 30.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: topContentCategory),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              ThuruCareIcons.plant,
                              color: Colors.white,
                              size: 60.0,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .18,
                                child: Container(
                                  width: 0.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white,
                                              width: 2.0))),
                                )),
                            Text(
                              disease.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Synonyms :  ",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    disease.synonyms,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ],
    );

    final bottomContentText = Text(
      disease.chemicalControl,
      style: TextStyle(fontSize: 14.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
          Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
        ));

    /* final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Center(
        child: Column(
          children: <Widget>[
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
            ),
            Text(
              "• " + disease.priventiveMesures[1],
              style: TextStyle(
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
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
                  fontSize: 13.0, color: Colors.black.withOpacity(0.6)),
            ),
            SizedBox(height: 6.0),

            //readButton
          ],
        ),
      ),
    ); */

    final bottomContent = Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          //DEFINITION ----------------------------------------

          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Definition",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              disease.definition,
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 0.0,
                height: 20.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.blueGrey.withAlpha(50), width: 1.5))),
              )),

          //Symptoms-------------------------------------------
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Symptoms",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              disease.symptoms,
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 0.0,
                height: 20.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.blueGrey.withAlpha(50), width: 1.5))),
              )),

          //Triggers-------------------------------------------
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Trigger",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              disease.trigger,
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 0.0,
                height: 20.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.blueGrey.withAlpha(50), width: 1.5))),
              )),

          //Triggers-------------------------------------------
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Preventive Measures",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "• " + disease.priventiveMesures[0],
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "• " + disease.priventiveMesures[1],
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 0.0,
                height: 20.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.blueGrey.withAlpha(50), width: 1.5))),
              )),

          //Biological Control ------------------------------------------
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Biological Control",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              disease.biologicalControl,
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 0.0,
                height: 20.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.blueGrey.withAlpha(50), width: 1.5))),
              )),

          //Chemical Control ------------------------------------------
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Chemical Control",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              disease.chemicalControl,
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: 0.0,
                height: 20.0,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.blueGrey.withAlpha(50), width: 1.5))),
              )),

          //Traditional Control ------------------------------------------
          SizedBox(
            height: 12.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  "Traditional Control",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              disease.biologicalControl,
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: "Ubuntu",
          backgroundColor: Colors.white),
      home: new WillPopScope(
        child: new Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[topContent, bottomContent],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
