import 'package:ea_frontend/mobile/credential_screen/splash_mobile.dart';
import 'package:ea_frontend/web/navbar_web_logged.dart';
import 'package:ea_frontend/web/profile_screen/profile_web.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/mobile/navbar_mobile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:ea_frontend/mobile/home_screen/challenge_mobile.dart';
import 'package:ea_frontend/mobile/profile_screen/friends_mobile.dart';
import 'package:ea_frontend/mobile/credential_screen/login_mobile.dart';
import 'package:ea_frontend/mobile/home_screen/qr_mobile.dart';
import 'package:ea_frontend/mobile/profile_screen/makefriends_mobile.dart';
import 'package:ea_frontend/mobile/credential_screen/register_mobile.dart';
import 'package:ea_frontend/web/navbar_web_default.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ea_frontend/web/credential_screen/login_web.dart';
import 'package:ea_frontend/web/navbar_web_logged.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            case '/profile_web':
              return MaterialPageRoute(
                  builder: (context) => const ProfileScreenWeb());
            case '/login_web':
              return MaterialPageRoute(
                  builder: (context) => const LoginScreenWeb());
            case '/navbar_web_logged':
              return MaterialPageRoute(
                  builder: (context) => const NavBarWebLogged());
            case '/makefriends_screen':
              return MaterialPageRoute(
                  builder: (context) => const MakeFriendsScreen());
            case '/navbar_mobile':
              return MaterialPageRoute(
                  builder: (context) => const NavBarMobile());
            default:
              if (kIsWeb) {
                return MaterialPageRoute(
                    builder: (context) => const NavBarWebDefault());
              } else {
                return MaterialPageRoute(
                    builder: (context) => const LoginScreen());
              }
          }
        });
  }
}
