
// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ea_frontend/widget/credential_textfield.dart';
import 'package:ea_frontend/widget/credential_button.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/widget/password_textfield.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class MyCustomWidget extends StatefulWidget {
//   @override
//   _MyCustomWidgetState createState() => _MyCustomWidgetState();
// }

// class _MyCustomWidgetState extends State<MyCustomWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               'Suppose this is an app in your Phone\'s Screen page.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             OpenContainer(
//               closedBuilder: (_, openContainer) {
//                 return Container(
//                   height: 80,
//                   width: 80,
//                   child: Center(
//                     child: Text(
//                       'App Logo',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               openColor: Colors.white,
//               closedElevation: 20,
//               closedShape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               transitionDuration: Duration(milliseconds: 700),
//               openBuilder: (_, closeContainer) {
//                 return SecondPage();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

void main() async {
  await dotenv.load();
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _a = true;
      });
    });
    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _b = true;
      });
    });
    Timer(Duration(milliseconds: 1300), () {
      setState(() {
        _c = true;
      });
    });
    Timer(Duration(milliseconds: 1700), () {
      setState(() {
        _e = true;
      });
    });
    Timer(Duration(milliseconds: 3400), () {
      setState(() {
        _d = true;
      });
    });
    Timer(Duration(milliseconds: 3850), () {
      setState(() {
        Navigator.of(context).pushReplacement(
          ThisIsFadeRoute(
            route: LoginScreen(),
          ),
        );
      });
    });
  }

  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: _d ? 900 : 2500),
              curve: _d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
              height: _d
                  ? 0
                  : _a
                      ? _h / 2
                      : 20,
              width: 20,
              // color: Colors.deepPurpleAccent,
            ),
            AnimatedContainer(
              duration: Duration(
                  seconds: _d
                      ? 1
                      : _c
                          ? 2
                          : 0),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d
                  ? _h
                  : _c
                      ? 80
                      : 20,
              width: _d
                  ? _w
                  : _c
                      ? 200
                      : 20,
              decoration: BoxDecoration(
                  color: _b ? Colors.black : Colors.transparent,
                  // shape: _c? BoxShape.rectangle : BoxShape.circle,
                  borderRadius:
                      _d ? BorderRadius.only() : BorderRadius.circular(30)),
              child: Center(
                child: _e
                    ? AnimatedTextKit(
                        totalRepeatCount: 1,
                        animatedTexts: [
                          FadeAnimatedText(
                            'EETAC Go',
                            duration: Duration(milliseconds: 1700),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget? page;
  final Widget route;

  ThisIsFadeRoute({this.page, required this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page ?? Container(),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: route,
          ),
        );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Text editing controllers
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    //Login method
    void logIn() async {
      if ((emailController.text != '') && (passwordController.text != '')) {
        try {
          var response = await Dio()
              .post('http://${dotenv.env['API_URL']}/auth/login', data: {
            "email": emailController.text,
            "password": passwordController.text
          });

          if (response.statusCode == 200) {
            Map<String, dynamic> payload = Jwt.parseJwt(response.toString());

            User u = User.fromJson(payload);
            var data = json.decode(response.toString());

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setString('token', data['token']);
            prefs.setString('idUser', u.idUser);
            prefs.setString('name', u.name);
            prefs.setString('surname', u.surname);
            prefs.setString('username', u.username);

            Navigator.pushNamed(context, '/navbar');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Attention!',
                message: 'Wrong credentials. Try again with other values.',
                contentType: ContentType.failure,
              ),
            ));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Attention!',
                message: 'Wrong credentials. Try again with other values.',
                contentType: ContentType.failure,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Atention!',
              message: 'Empty credentials. Please, try again.',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1080,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          //Logo
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 47.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/eetac_go.png',
                                  height: 185,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 5),

                          //Email address textfield
                          CredentialTextField(
                              controller: emailController,
                              labelText: "Email address",
                              obscureText: false),

                          const SizedBox(height: 10),

                          //Password textfield
                          PasswordTextField(
                              controller: passwordController,
                              labelText: "Password",
                              obscureText: true),

                          const SizedBox(height: 20),

                          //Log in button
                          CredentialButton(
                            buttonText: "LOG IN",
                            onTap: logIn,
                          ),

                          const SizedBox(height: 20),

                          //Or continue with
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Color.fromARGB(255, 242, 242, 242),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Text(
                                    'Or continue with',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 242, 242, 242),
                                        fontSize: 17),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Color.fromARGB(255, 242, 242, 242),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          //Google
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'images/google.png',
                                height: 65,
                              ),
                            ),
                          ),

                          //Don't have an account?
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 242, 242, 242),
                                    fontSize: 17),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/register_screen');
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 222, 66, 66),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ]),
          ),
        ),
      ),
    );
  }
}



      