import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_cameraview/flutter_cameraview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thuru_care_client/pages/navigation/seventh_screen.dart';

import 'settings_page.dart';

class CameraHomeScreen extends StatefulWidget {
  CameraHomeScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CameraHomeScreen> {
  CameraViewController _cameraViewController;
  Icon _flashButtonIcon = Icon(Icons.flash_off);
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
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 120.0,
                padding: EdgeInsets.all(20.0),
                color: Color.fromRGBO(00, 99, 00, 0.4),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          onTap: () {
                            _onTakePictureButtonPressed();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/images/ic_shutter_1.png',
                              width: 72.0,
                              height: 72.0,
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
                            color: Colors.white,
                            child: _flashButtonIcon,
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
              top: 8.0,
              right: 8.0,
              width: 40.0,
              height: 40.0,
              child: new IconButton(
                color: Colors.white,
                icon: new Icon(Icons.settings, size: 25.0),
                onPressed: () => _onSettingsButtonPressed(context),
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
    Icon icon;
    String msg;
    switch (flash) {
      case Flash.Off:
        flash = Flash.On;
        msg = "Flash On";
        icon = Icon(Icons.flash_on);
        break;

      case Flash.On:
        flash = Flash.Auto;
        msg = "Flash Auto";
        icon = Icon(Icons.flash_auto);
        break;

      case Flash.Auto:
        flash = Flash.Torch;
        msg = "Torch Mode";
        icon = Icon(Icons.highlight);
        break;

      case Flash.Torch:
        flash = Flash.Off;
        msg = "Flash Off";
        icon = Icon(Icons.flash_off);
        break;
    }

    await _cameraViewController.setFlash(flash);

    setState(() {
      _flashButtonIcon = icon;
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
    _cameraViewController.takePicture();
  }

  void _onPictureFileCreated(String filePath) async {
    if (filePath == null || filePath.isEmpty) {
      return;
    }
    showToast("Picture saved to " + filePath);

    //Build thumbnail
    Image image = new Image.file(new File(filePath),
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        scale: 0.2,
        filterQuality: FilterQuality.low);

    setState(() {
      _thumbnailImage = image;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPreview(filePath)),
    );
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
}