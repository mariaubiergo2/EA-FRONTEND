// import 'package:camera/camera.dart';
import 'package:ea_frontend/pages/challenge_screen.dart';
import 'package:ea_frontend/pages/profile_screen/friends_screen.dart';
import 'package:ea_frontend/pages/credential_screen/login_screen.dart';
import 'package:ea_frontend/pages/home_screen/qr_screen.dart';
import 'package:ea_frontend/pages/profile_screen/gallery_screen.dart';
import 'package:ea_frontend/pages/profile_screen/makefriends_screen.dart';
import 'package:ea_frontend/pages/credential_screen/register_screen.dart';
import 'package:ea_frontend/pages/credential_screen/splash_screen.dart';
import 'package:ea_frontend/pages/profile_screen/takepicture_screen.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/pages/navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
    //  WidgetsFlutterBinding.ensureInitialized();
    // // Obtain a list of the available cameras on the device.
    // final cameras = await availableCameras();
    // // Get a specific camera from the list of available cameras.
    // final firstCamera = cameras.first;
    // // runApp(MyApp(camera: firstCamera));
    runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    // required this.camera,
  });

  // final CameraDescription camera;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EETAC Go',
        home: const SplashScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/register_screen':
              return MaterialPageRoute(
                  builder: (context) => const RegisterScreen());
            case '/friends_screen':
              return MaterialPageRoute(
                  builder: (context) => const FriendsScreen());
            case '/challenge_screen':
              return MaterialPageRoute(
                  builder: (context) => const MyChallengePage());
            case '/qr_screen':
              return MaterialPageRoute(builder: (context) => const MyQR());
            case '/makefriends_screen':
              return MaterialPageRoute(
                  builder: (context) => const MakeFriendsScreen());
            case '/navbar':
              return MaterialPageRoute(builder: (context) => const NavBar());
            default:
              return MaterialPageRoute(
                  builder: (context) => const LoginScreen());
          }
        });
  }
}
