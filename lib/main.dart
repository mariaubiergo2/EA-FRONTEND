import 'package:ea_frontend/pages/credential_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/pages/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ea_frontend/pages/challenge_screen.dart';
import 'package:ea_frontend/pages/profile_screen/friends_screen.dart';
import 'package:ea_frontend/pages/credential_screen/login_screen.dart';
import 'package:ea_frontend/pages/home_screen/qr_screen.dart';
import 'package:ea_frontend/pages/profile_screen/makefriends_screen.dart';
import 'package:ea_frontend/pages/credential_screen/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EETAC Go',
        //home: const SplashScreen(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es'), Locale('ca')],
        // locale: const Locale('es'),
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
