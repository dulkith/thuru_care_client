import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:thuru_care_client/models/PredictionModel.dart';
import 'package:thuru_care_client/pages/navigation/result_list.dart';

class CameraPreview extends StatefulWidget {
  final String _imagePath;

  CameraPreview(this._imagePath);

  @override
  CameraPreviewState createState() {
    return new CameraPreviewState(_imagePath);
  }
}

class CameraPreviewState extends State<CameraPreview> {
  final String _imagePath;
  bool isLoading = false;

  CameraPreviewState(this._imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ClipRect(
                child: PhotoView(
                  imageProvider: AssetImage(_imagePath),
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  initialScale: PhotoViewComputedScale.covered,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(35.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: const Text(
                  "Your Crop image Preview",
                  style: const TextStyle(fontSize: 22.0, color: Colors.white),
                ),
              ),
            ),
            isLoading
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black.withOpacity(0.7),
                      child: SizedBox(
                        child: new CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation(Colors.green[800]),
                            strokeWidth: 5.0),
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.bottomCenter,
                    child: RawMaterialButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          processImage(File(_imagePath),context);
                        });
                      },
                      child: new Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.red[700],
                      padding: const EdgeInsets.all(15.0),
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 35),
                  ),
          ],
        ),
      ),
    );
  }

  processImage(File imageFile, var context) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();
    // String to uri
    var uri = Uri.parse("http://35.247.186.2:9000/");
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);
    // send
    StreamedResponse response;
    try {

      response = await request.send();
    } on Exception catch(e) {
      Alert(
        type: AlertType.error,
        title: "ERROR",
        desc: "Wrong object detected. This is not a Crop",
        buttons: [
          DialogButton(
            child: Text(
              "This is Crop",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              print("Continue with another page");

            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
          DialogButton(
            child: Text(
              "New Picture",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(null),
            color: Colors.blueAccent,
          ),

        ],
      ).show();
    }

    setState(() {
      isLoading = false;
    });

    print(response.statusCode);
    final respStr = await response.stream.bytesToString();
    // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //    print(value);
    // });
    //Process response to Object list.
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var result = json.decode(respStr);
      //var model = PredictionModel.fromJason(result[0]);
      var resultList =
          result.map((m) => new PredictionModel.fromJson(m)).toList();

      Navigator.pop(context,true);
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => new ResultList(resultList),
      ));

      print(resultList[0].disease);
      print(resultList[1].disease);
      print(resultList[2].disease);
      print(resultList[3].disease);
      print(resultList[4].disease);

      return resultList;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

  }
}
