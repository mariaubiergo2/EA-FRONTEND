// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

// class GalleryScreen extends StatefulWidget {
//   const GalleryScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _GalleryScreenState createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   @override
//   void initState() {
//     super.initState(); 
//   }

//   Future<void> pickImageFromGallery(ImageSource source) async {
//     try {
//       final imagePicker = ImagePicker();
//       final pickedImage = await imagePicker.pickImage(source: source);
//       if (pickedImage != null) {
//         // Do something with the picked image
//         final imageTemporary = File(pickedImage.path);
//         print(imageTemporary);
//       }
//     } on PlatformException catch (e) {
//       print('Failed to pick the image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     pickImageFromGallery(ImageSource.gallery);
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: ElevatedButton(
//         onPressed: {}, //pickImageFromGallery(ImageSource.camera),
//         child: const Text('Pick from Gallery'),
//       ),
//     );
//   }
// }
