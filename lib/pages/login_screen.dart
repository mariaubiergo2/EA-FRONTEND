import 'dart:convert';
import 'package:ea_frontend/widget/credential_textfield.dart';
import 'package:ea_frontend/widget/credential_button.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/pages/register_screen.dart';
import 'package:ea_frontend/pages/initial_screen.dart';
import 'package:lit_starfield/lit_starfield.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late String idUser = "";
    late String _email;
    late String _password;

    //Text editing controllers
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    //Login method
    void logIn() async {
      if ((emailController.text != '') && (passwordController.text != '')) {
        try {
          var response = await Dio().post("http://127.0.0.1:3002/auth/login",
              data: {
                "email": emailController.text,
                "password": passwordController.text
              });

          print(response.statusCode);

          if (response.statusCode == 200) {
            Map<String, dynamic> payload = Jwt.parseJwt(response.toString());

            print('Token:' + payload.toString());

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
                          CredentialTextField(
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
