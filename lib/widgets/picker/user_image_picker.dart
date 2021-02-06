import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickedFn;

  UserImagePicker(this.imagePickedFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageFile =
        await _picker.getImage(source: src, imageQuality: 50, maxWidth: 150);

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickedFn(_pickedImage);
    } else {
      print("No Image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icon(Icons.photo_camera_outlined),
              label: Text(
                "Add Photo\n from  Camera",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ),
            FlatButton.icon(
              textColor: Theme.of(context).primaryColor,
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icon(Icons.photo_outlined),
              label: Text(
                "Add Photo\n from  Gallery",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
