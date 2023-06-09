// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:ea_frontend/pages/credential_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/pages/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ea_frontend/pages/challenge_screen.dart';
import 'package:ea_frontend/pages/profile_screen/friends_screen.dart';
import 'package:ea_frontend/pages/home_screen/home_screen.dart';
import 'package:ea_frontend/pages/credential_screen/login_screen.dart';
import 'package:ea_frontend/pages/home_screen/qr_screen.dart';
import 'package:ea_frontend/pages/profile_screen/makefriends_screen.dart';
import 'package:ea_frontend/pages/credential_screen/register_screen.dart';
import 'package:ea_frontend/pages/credential_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/pages/navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
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
        theme: ThemeData.light().copyWith(
          brightness: Brightness.light,
          backgroundColor: Color.fromARGB(255, 242, 242, 242),
          dividerColor: Color.fromARGB(255, 25, 25, 25),
          buttonTheme: ButtonThemeData(
              buttonColor: Color.fromARGB(255, 222, 66, 66),
              textTheme: ButtonTextTheme.primary),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Color.fromARGB(255, 25, 25, 25),
            ),
            headline6: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          brightness: Brightness.dark,
          backgroundColor: Color.fromARGB(255, 25, 25, 25),
          dividerColor: Color.fromARGB(255, 242, 242, 242),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Color.fromARGB(255, 242, 242, 242),
            ),
            headline6: TextStyle(
              color: Colors.red,
            ),
          ),
          // Other dark theme properties
        ),
        themeMode: ThemeMode.system,
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
