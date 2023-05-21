import 'package:ea_frontend/pages/profile_screen/friends_screen.dart';
import 'package:ea_frontend/pages/home_screen/home_screen.dart';
import 'package:ea_frontend/pages/credential_screen/login_screen.dart';
import 'package:ea_frontend/pages/home_screen/qr_screen.dart';
import 'package:ea_frontend/pages/profile_screen/makefriends_screen.dart';
import 'package:ea_frontend/pages/credential_screen/register_screen.dart';
import 'package:ea_frontend/pages/credential_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/pages/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material Login',
        home: const SplashScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/register_screen':
              return MaterialPageRoute(
                  builder: (context) => const RegisterScreen());
            case '/friends_screen':
              return MaterialPageRoute(
                  builder: (context) => const FriendsScreen());

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
