// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:ea_frontend/mobile/profile_screen/edit_info.dart';
import 'package:ea_frontend/mobile/profile_screen/edit_password.dart';
import 'package:flutter/material.dart';
import 'services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ea_frontend/mobile/navbar_mobile.dart';
import 'package:ea_frontend/web/navbar_web_logged.dart';
import 'package:ea_frontend/web/navbar_web_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ea_frontend/mobile/home_screen/qr_screen.dart';
import 'package:ea_frontend/web/profile_screen/profile_web.dart';
import 'package:ea_frontend/web/credential_screen/login_web.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ea_frontend/mobile/credential_screen/login_screen.dart';
import 'package:ea_frontend/mobile/credential_screen/splash_screen.dart';
import 'package:ea_frontend/mobile/credential_screen/register_screen.dart';

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
  //supportedLocales: L10n.all,
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
          bodyText2: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
          ),
          headline1: TextStyle(
            color: Color.fromARGB(255, 217, 217, 217),
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
          headline6: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      //home: SplashScreen(),
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
          //----------------------- M O B I L E -----------------------//

          case '/register_screen':
            return MaterialPageRoute(
                builder: (context) => const RegisterScreen());

          case '/qr_screen':
            return MaterialPageRoute(builder: (context) => const MyQR());

          case '/navbar':
            return MaterialPageRoute(builder: (context) => const NavBar());

          case '/edit_account':
            return MaterialPageRoute(
                builder: (context) => const EditInfoScreen());

          case '/edit_password':
            return MaterialPageRoute(
                builder: (context) => const EditPasswordScreen());

          //-------------------------- W E B --------------------------//

          case '/navbar_web_logged':
            return MaterialPageRoute(
                builder: (context) => const NavBarWebLogged());

          case '/login_web':
            return MaterialPageRoute(
                builder: (context) => const LoginScreenWeb());

          case '/profile_web':
            return MaterialPageRoute(
                builder: (context) => const ProfileScreenWeb());

          default:
            if (kIsWeb) {
              return MaterialPageRoute(
                  builder: (context) => const NavBarWebDefault());
            } else {
              return MaterialPageRoute(
                  builder: (context) => const LoginScreen());
            }
        }
      },
    );
  }
}
