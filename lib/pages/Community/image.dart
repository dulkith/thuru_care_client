import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;

  ImageInput(this.setImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 500.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  File  get extractImage{
    return _imageFile;
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Pick an Image to Upload",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Use Camera"),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                    }),
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Use Device Storage"),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                    }),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      children: <Widget>[
        _imageFile == null
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add_to_photos),
                SizedBox(width: 5.0),
                Text("Select an Image")

              ]
            )
            : Image.file(_imageFile,
                fit: BoxFit.cover,
                height: 300.0,
                width: MediaQuery.of(context).size.width * 0.95,
                alignment: Alignment.topCenter),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlineButton(
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
            onPressed: () {
              _openImagePicker(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    color: color,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    "Add Image",
                    style: TextStyle(color: color),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
