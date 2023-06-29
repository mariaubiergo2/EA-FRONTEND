// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'screens/chat_screen/chat_screen.dart';
import 'services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ea_frontend/screens/navbar_mobile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ea_frontend/screens/profile_screen/edit_info.dart';
import 'package:ea_frontend/screens/profile_screen/edit_password.dart';
import 'package:ea_frontend/screens/credential_screen/login_screen.dart';
import 'package:ea_frontend/screens/credential_screen/register_screen.dart';
import 'package:ea_frontend/screens/credential_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: "Dev Project",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint(fcmToken);
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EETAC Go',
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        dividerColor: Color.fromARGB(255, 37, 37, 37),
        buttonTheme: ButtonThemeData(
            buttonColor: Color.fromARGB(255, 222, 66, 66),
            textTheme: ButtonTextTheme.primary),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
          ),
          bodyText2: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
          ),
          headline1: TextStyle(
            color: Color.fromARGB(255, 217, 217, 217),
          ),
          headline2: TextStyle(
            color: Color.fromARGB(255, 222, 66, 66),
          ),
          headline3: TextStyle(
            color: Color.fromARGB(255, 226, 226, 226),
          ),
          headline4: TextStyle(
            color: Color.fromARGB(255, 222, 66, 66),
          ),
          headline5: TextStyle(
            color: Colors.white,
          ),
          headline6: TextStyle(
            color: Color.fromARGB(255, 222, 66, 66),
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
          bodyText2: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
          ),
          headline1: TextStyle(
            color: Color.fromARGB(255, 242, 242, 242),
          ),
          headline2: TextStyle(
            color: Color.fromARGB(255, 222, 66, 66),
          ),
          headline3: TextStyle(
            color: Color.fromARGB(255, 242, 242, 242),
          ),
          headline4: TextStyle(
            color: Color.fromARGB(255, 252, 197, 31),
          ),
          headline5: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
          ),
          headline6: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: SplashScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('ca'),
        Locale('zh')
      ],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/register_screen':
            return MaterialPageRoute(
                builder: (context) => const RegisterScreen());

          case '/navbar':
            return MaterialPageRoute(builder: (context) => const NavBar());
          case '/chat':
            return MaterialPageRoute(builder: (context) => const ChatWidget());

          case '/edit_account':
            return MaterialPageRoute(
                builder: (context) => const EditInfoScreen());

          case '/edit_password':
            return MaterialPageRoute(
                builder: (context) => const EditPasswordScreen());

          default:
            return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
      },
    );
  }
}
