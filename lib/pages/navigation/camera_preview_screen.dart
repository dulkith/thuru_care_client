

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CameraPreview extends StatelessWidget {
  final String _imagePath;

  CameraPreview(this._imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: const Text(
                      "Your Crop image Preview",
                      style: const TextStyle(fontSize: 22.0),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
                    height: 425.0,
                    child: ClipRect(
                      child: PhotoView(
                        imageProvider: AssetImage(_imagePath),
                        maxScale: PhotoViewComputedScale.covered * 2.0,
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        initialScale: PhotoViewComputedScale.covered,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {

                    },
                    padding: EdgeInsets.all(10.0),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.menu),
                        new Text("Feed")
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void processImage() {
  }
}