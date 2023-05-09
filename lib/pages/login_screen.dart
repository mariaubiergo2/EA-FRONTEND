import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/pages/register_screen.dart';
import 'package:ea_frontend/pages/initial_screen.dart';
import 'package:lit_starfield/lit_starfield.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ea_frontend/widget/black_textfield_email.dart';
import 'package:ea_frontend/widget/black_textfield_password.dart';

import '../models/user.dart';
import '../models/token.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String idUser = "";
  late String _email;
  late String _password;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  // Create storage
  final storage = new FlutterSecureStorage();
  var salt = '\$2b\$12\$0O5iZrh9JNnOgBP/NprFBe2SS5scgrLsA.Dx6DsmhL3VLQpN/q4Uy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 207, 5),
      body: SafeArea(
          child: Center(
              child: Column(children: <Widget>[
        SizedBox(height: 75),
        // const LitStarfieldContainer(
        //   animated: true,
        //   number: 500,
        //   velocity: 0.85,
        //   depth: 0.9,
        //   scale: 4,
        //   starColor: Color.fromARGB(255, 255, 247, 0),
        //   backgroundDecoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Color(0xFF031936),
        //         Color.fromRGBO(9, 21, 155, 0.98),
        //         //Color.fromARGB(255, 108, 87, 16),
        //         //Color.fromARGB(255, 11, 7, 255),
        //         //Color.fromARGB(255, 43, 46, 255),
        //         //Color.fromARGB(255, 209, 0, 146),
        //         //Color.fromARGB(255, 156, 102, 0),
        //         Color(0xFF031936),
        //       ],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        // ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/logoApp.png'),
                ),
                const Text('EETACgo',
                    style: TextStyle(fontSize: 75, fontWeight: FontWeight.bold)),
                const Divider(
                  height: 30,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: emailController,
                  cursorColor: Color.fromARGB(255, 222, 66, 66),
                  style: TextStyle(color: Color.fromARGB(255, 239, 239, 239), fontSize: 17),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    hintText: 'Email',
                    labelText: 'Write your email...',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 17),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Color.fromARGB(255, 25, 25, 25),
                    filled: true,
                      // labelStyle: const TextStyle(
                      //     color: Color.fromRGBO(255, 255, 255, 1)),
                      // hintStyle: const TextStyle(
                      //   color: Color.fromRGBO(0, 115, 216, 0.988),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 222, 66, 66), width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),                  
                      suffixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 222, 66, 66),),
                      ),
                  onSubmitted: (valor) {
                    _email = valor;
                    print('El email es $_email');
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  cursorColor: Color.fromARGB(255, 222, 66, 66),
                  style: TextStyle(color: Color.fromARGB(255, 239, 239, 239), fontSize: 17),
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    hintText: 'Password',
                    labelText: 'Write your password...',
                    labelStyle: TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 17),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Color.fromARGB(255, 25, 25, 25),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 222, 66, 66), width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),                  
                      suffixIcon: const Icon(Icons.lock_outline, color: Color.fromARGB(255, 222, 66, 66),),
                      ),
                  onSubmitted: (valor) {
                    _password = valor;
                    print('El email es $_password');
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          backgroundColor:
                              const Color.fromRGBO(0, 115, 216, 0.988),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(20.0)),
                          padding: EdgeInsets.all(13.0),
                          textStyle: const TextStyle(
                            fontFamily: 'NerkoOne',
                            fontSize: 20.0,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          )),
                      onPressed: () async {
                        if ((emailController.text != ' ') &&
                            (passwordController.text != ' ')) {
                          try {
                            var response = await Dio()
                                .post("http://127.0.0.1:3002/auth/login",
                                    // "http://192.168.56.1:3002/auth/login",
                                    data: {
                                  "email": emailController.text,
                                  "password": passwordController.text
                                  // "password": await DBCrypt()
                                  //     .hashpw(passwordController.text, salt)
                                });
                            print(response.statusCode);
                            if (response.statusCode == 200) {
                              Map<String, dynamic> payload =
                                  Jwt.parseJwt(response.toString());
                              print('Token destoken:' + payload.toString());

                              User u = User.fromJson(payload);
                              var data = json.decode(response.toString());
                              print(data['token']);
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('token', data['token']);
                              prefs.setString('idUser', u.idUser);
                              prefs.setString('name', u.name);
                              prefs.setString('surname', u.surname);
                              prefs.setString('username', u.username);

                              Navigator.pushNamed(context, '/initial_screen');
                            } else {
                              print(response.statusCode);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Wrong credentials!',
                                  message: 'Please, try again',

                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                  contentType: ContentType.failure,
                                ),
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Wrong credentials!',
                                message: 'Please, try again',

                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                contentType: ContentType.failure,
                              ),
                            ));
                            //   SnackBar(
                            //     behavior: SnackBarBehavior.floating,
                            //     backgroundColor: Colors.transparent,
                            //     elevation: 0,
                            //     content: Container(
                            //       padding: EdgeInsets.all(16),
                            //       height: 90,
                            //       decoration: BoxDecoration(
                            //         color: Colors.red,
                            //         borderRaColor.fromARGB(0, 137, 75, 75).all(Radius.circular(20)),
                            //       ),
                            //       child: Row(
                            //         children: [
                            //           const SizedBox(width: 40),
                            //           Expanded(
                            //             child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 'Wrong credentials!',
                            //                 style: TextStyle(fontSize: 18, color:Colors.white),
                            //                 ),
                            //               Text(
                            //                 'Error: '+e.toString(),
                            //                 style: TextStyle(fontSize: 12, color:Colors.white),
                            //                 maxLines: 2,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 ),
                            //               ],
                            //               )
                            //         ),
                            //         ],
                            //       ),
                            //   ),
                            // ));
                          }
                        }
                      },
                      child: const Text('Log in'),
                    )),
                const SizedBox(height: 20),
                const Text(
                  "Are you a new user? Create an account!",
                  style: TextStyle(
                      fontFamily: 'NerkoOne',
                      fontSize: 18.0,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor:
                            const Color.fromRGBO(0, 115, 216, 0.988),
                        shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.all(13.0),
                        textStyle: const TextStyle(
                          fontFamily: 'NerkoOne',
                          fontSize: 20.0,
                        )),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register_screen');
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(fontFamily: 'NerkoOne', fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            )),
      ]),
    ),
      ),
    );

  }
}
