import 'package:ea_frontend/pages/initial_screen.dart';
import 'package:ea_frontend/pages/login_screen.dart';
import 'package:ea_frontend/pages/register_screen.dart';
import 'package:ea_frontend/pages/splash_screen.dart';
import 'package:flutter/material.dart';

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
             case '/initial_screen':
              return MaterialPageRoute(builder: (context) => InitialScreen());
            default:
              return MaterialPageRoute(builder: (context) => LoginScreen());
          }
        });
  }
}
