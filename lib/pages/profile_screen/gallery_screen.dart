import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    super.initState(); 
  }

  Future<void> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // Do something with the picked image
      print("He pillat una foto de la galeria");
      print(pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    pickImageFromGallery();
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: pickImageFromGallery,
        child: const Text('Pick from Gallery'),
      ),
    );
  }
}
