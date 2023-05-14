import 'dart:convert';
import 'package:ea_frontend/widget/black_textfield.dart';
import 'package:ea_frontend/widget/button_styles.dart';
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
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../models/token.dart';
import '../widget/alert_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  final salt = '\$2b\$12\$0O5iZrh9JNnOgBP/NprFBe2SS5scgrLsA.Dx6DsmhL3VLQpN/q4Uy';

  @override
  Widget build(BuildContext context) {
    late String idUser = "";
    late String _email;
    late String _password;
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 207, 5),
      body: SafeArea(
          child: Center(
            child: Column(children: <Widget>[
            SizedBox(height: 5),
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
                    BlackTextField(controller: emailController, hintText: "Email", labelText: "Write your email...", obscureText: false, icon:Icons.email),
                    const SizedBox(height: 10),
                    BlackTextField(controller: passwordController, hintText: "Password", labelText: "Write your password...", obscureText: true, icon:Icons.lock_outline),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: myButtonStyle,
                          onPressed: () async {
                            if ((emailController.text != '') &&
                                (passwordController.text != '')) {
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Wrong credentials!',
                                          message: 'Please, try again',
                                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                          contentType: ContentType.failure,
                                        ),
                                      ),);
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
                                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                          contentType: ContentType.failure,
                                        ),
                                      ),);
                            //   showDialog(
                            //      context: context,
                            //     builder: (BuildContext context) {
                            //        return CustomAlertDialog(
                            //          title: 'Atention!',
                            //         message: 'There are empty fields. Please, try again...',
                            // );},);
                          }},
                          child: const Text('Log in'),
                        ),
                      ),
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
                          style: myButtonStyle,
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
