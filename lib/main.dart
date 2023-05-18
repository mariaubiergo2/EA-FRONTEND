import 'package:ea_frontend/pages/profile_screen/friends_screen.dart';
import 'package:ea_frontend/pages/home_screen/home_screen.dart';
import 'package:ea_frontend/pages/credential_screen/login_screen.dart';
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
        home: SplashScreen(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/register_screen':
              return MaterialPageRoute(builder: (context) => RegisterScreen());
            /*case '/profile_screen':
              return MaterialPageRoute(builder: (context) => ProfileScreen());
            */
            case '/friends_screen':
              return MaterialPageRoute(
                  builder: (context) => const FriendsScreen());

            case '/initial_screen':
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            default:
              return MaterialPageRoute(builder: (context) => const NavBar());
            //Realmente return MaterialPageRoute(builder: (context) => const LoginScreen());
          }
        });
  }
}
