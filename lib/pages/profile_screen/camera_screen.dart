// // ignore_for_file: use_build_context_synchronously

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import '../../models/user.dart';
// import '../../widget/card_user_widget.dart';

// void main() async {
//   await dotenv.load();
// }

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreen();
// }

// class _CameraScreen extends State<CameraScreen> {
//   // PickedFile? _imageFile;
//   // final ImagePicker _picker = ImagePicker();
//   List<CameraDescription>? _cameras;
//   CameraController? _controller;
//   CameraImage? _image;

//   @override
//   void initState() {
//     super.initState();
//     getUserInfo();
//     initCamera();
//   }

//   @override
//   void dispose() {
//     _controller!.dispose();
//     super.dispose();
//   }

// // void takePhoto(ImageSource source, ImagePicker picker) async{
// //     final pickedFile = await picker.getImage(
// //       source: source,
// //     );
// //     setState(() {
// //       _imageFile = pickedFile!;
// //     });
// //   }

//   Future<void> initCamera() async {

//     // Ensure that plugin services are initialized so that `availableCameras()`
//     // can be called before `runApp()`
//     WidgetsFlutterBinding.ensureInitialized();

//     // Obtain a list of the available cameras on the device.
//     final cameras = await availableCameras();

//     // Get a specific camera from the list of available cameras.
//     final firstCamera = cameras.first;

//     // _cameras = await availableCameras();
//     // _controller = CameraController(_cameras![0], ResolutionPreset.medium);
//     // await _controller?.initialize();
//   }

//   Future<void> takePicture() async {
//     if (!_controller!.value.isInitialized) {
//       return;
//     }
//     try {
//       await _controller!.takePicture().then((XFile file) {
//         // Do something with the captured image file
//         // e.g., save it to local storage or display it in the app
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future clearInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }

//   Future getUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//     });
//   }


//   @override
//   Widget build(BuildContext context) {

//     return null;
//   }
// }
