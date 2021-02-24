import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

import 'package:flutter_cameraview/flutter_cameraview.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:thuru_care_client/pages/navigation/camera_preview_screen.dart';
import 'package:path/path.dart' as p;
import 'dart:math' as Math;

import 'settings_page.dart';

class CameraHomeScreen extends StatefulWidget {
  CameraHomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CameraHomeScreen> {
  CameraViewController _cameraViewController;
  Image _flashButtonImage = Image.asset(
    'assets/images/ic_flash_camera_off.png',
    color: Colors.grey[200],
    width: 42.0,
    height: 42.0,
  );
  Image _thumbnailImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            CameraView(onCreated: _onCameraViewCreated),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(35.0),
                child: const Text(
                  "Take a picture of your crop",
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 120.0,
                padding: EdgeInsets.all(20.0),
                color: Color.fromRGBO(0, 150, 0, 0.3),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          onTap: () {
                            _onTakePictureButtonPressed();
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            child: Image.asset(
                              'assets/images/ic_shutter_1.png',
                              width: 75.0,
                              height: 75.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          onTap: () {
                            _onFlashButtonPressed();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: _flashButtonImage,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          onTap: () {
                            _onCameraFacingButtonPressed();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/images/ic_switch_camera_3.png',
                              color: Colors.grey[200],
                              width: 42.0,
                              height: 42.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Settings button
            Positioned(
              top: 25.0,
              left: 8.0,
              width: 40.0,
              height: 40.0,
              child: new IconButton(
                color: Colors.white,
                icon: new Icon(Icons.arrow_back_ios, size: 25.0),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),

            //thumbnail & gallery button
            Positioned(
                bottom: (MediaQuery.of(context).size.height / 2 - 160),
                width: 40.0,
                height: 40.0,
                right: 15.0,
                child: new RaisedButton(
                    color: Colors.black,
                    shape: new CircleBorder(),
                    padding: EdgeInsets.all(0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 20.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: _thumbnailImage),
                    ),
                    onPressed: () => _openImageGallery()))
          ],
        ),
      ),
    );
  }

  void _onCameraViewCreated(CameraViewController controller) {
    _cameraViewController = controller;
    _cameraViewController.onPictureFileCreated = _onPictureFileCreated;
  }

  void _onFlashButtonPressed() async {
    if (!await _cameraViewController.isOpened()) {
      showToast("Error: Camera not opened!");
      return;
    }

    Flash flash = await _cameraViewController.getFlash();
    Image image;
    String msg;
    switch (flash) {
      case Flash.Off:
        flash = Flash.On;
        msg = "Flash On";
        image = Image.asset(
          'assets/images/ic_flash_camera.png',
          color: Colors.grey[200],
          width: 42.0,
          height: 42.0,
        );
        break;

      case Flash.On:
        flash = Flash.Auto;
        msg = "Flash Auto";
        image = Image.asset(
          'assets/images/ic_flash_camera_auto.png',
          color: Colors.grey[200],
          width: 42.0,
          height: 42.0,
        );
        break;

      case Flash.Auto:
        flash = Flash.Torch;
        msg = "Torch Mode";
        image = Image.asset(
          'assets/images/ic_flash_camera_tourch.png',
          color: Colors.grey[200],
          width: 42.0,
          height: 42.0,
        );
        break;

      case Flash.Torch:
        flash = Flash.Off;
        msg = "Flash Off";
        image = Image.asset(
          'assets/images/ic_flash_camera_off.png',
          color: Colors.grey[200],
          width: 42.0,
          height: 42.0,
        );
        break;
    }

    await _cameraViewController.setFlash(flash);

    setState(() {
      _flashButtonImage = image;
    });

    showToast(msg);
  }

  void _onCameraFacingButtonPressed() async {
    if (!await _cameraViewController.isOpened()) {
      showToast("Error: Camera not opened!");
      return;
    }

    Facing facing = await _cameraViewController.getFacing();
    String msg;
    if (facing == Facing.Back) {
      facing = Facing.Front;
      msg = "Front camera";
    } else {
      facing = Facing.Back;
      msg = "Back camera";
    }
    await _cameraViewController.setFacing(facing);

    showToast(msg);
  }

  void _onTakePictureButtonPressed() async {
    if (!await _cameraViewController.isOpened()) {
      showToast("Error: Camera not opened!");
      return;
    }
    Directory appDocDir = await getTemporaryDirectory();
    String _filePath = appDocDir.path;
    int rand = new Math.Random().nextInt(10000);

    _cameraViewController.takePicture('$_filePath/img_$rand.jpg');
  }

  void _onPictureFileCreated(String filePath) async {
    if (filePath == null || filePath.isEmpty) {
      return;
    }

    File file = File(filePath);

    Directory appDocDir = await getExternalStorageDirectory();
    String targetPath = appDocDir.path;
    targetPath = p.join(targetPath, "Pictures", "Thuru_Care");
    Directory(targetPath).create(recursive: true);

    DateTime now = DateTime.now();
    targetPath = p.join(
        targetPath,
        sprintf("IMG_%d%02d%02d_%02d%02d%02d.jpg",
            [now.year, now.month, now.day, now.hour, now.minute, now.second]));

    var imgFile = await testCompressAndGetFile(file, targetPath);

    showToast("Picture saved to " + targetPath);
    DefaultCacheManager().emptyCache(); // clean cash memory.

    //Build thumbnail
    Image image = new Image.file(new File(targetPath),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        scale: 0.2,
        filterQuality: FilterQuality.low);

    setState(() {
      _thumbnailImage = image;
    });
    Navigator.pop(context,true);
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => new CameraPreview(targetPath),
    ));
  }

  void _openImageGallery() async {
    await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onSettingsButtonPressed(BuildContext context) async {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new SettingsPage()));
  }

  void showToast(String msg) async {
    Fluttertoast.cancel(); //Hides previous toast message
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
      minWidth: 600,
      minHeight: 1000,
      rotate: 90,
    );
    return result;
  }
}
