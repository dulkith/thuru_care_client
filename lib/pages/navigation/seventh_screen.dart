import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

class CameraPreview extends StatefulWidget {
  String _imagePath;

  CameraPreview(this._imagePath);

  @override
  _MyAppState createState() => new _MyAppState(_imagePath);
}

class _MyAppState extends State<CameraPreview> {
  String _imagePath;

  _MyAppState(this._imagePath);

  @override
  void initState() {
    super.initState();
    getFileImage();
  }

  ImageProvider provider;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: Column(
            children: <Widget>[
              AspectRatio(
                child: Image(
                  image:
                      provider ?? AssetImage("assets/images/ic_no_image.png"),
                  width: 500,
                  fit: BoxFit.contain,
                ),
                aspectRatio: 1 / 1,
              ),
              FlatButton(
                child: Text('CompressAndGetFile and rotate 90'),
                onPressed: getFileImage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }

  void getFileImage() async {
    File file = File(_imagePath);
    var targetPath = _imagePath;
    var imgFile = await testCompressAndGetFile(file, targetPath);
    provider = FileImage(imgFile);
    setState(() {});
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
      minWidth: 400,
      minHeight: 700,
      rotate: 90,
  );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }
}
