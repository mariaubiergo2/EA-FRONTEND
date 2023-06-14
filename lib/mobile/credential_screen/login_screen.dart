// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:ea_frontend/services/auth_service.dart';
import 'package:ea_frontend/widget/credential_screen/credential_textfield.dart';
import 'package:ea_frontend/widget/credential_screen/credential_button.dart';
import 'package:ea_frontend/widget/profile_screen/square_tile.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/widget/credential_screen/password_textfield.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

void main() async {
  await dotenv.load();
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Text editing controllers
    final passwordController = TextEditingController();
    final emailController = TextEditingController();
    //Login with Google

    //Login method
    void logIn() async {
      if ((emailController.text != '') && (passwordController.text != '')) {
        try {
          var response = await Dio().post(
            'http://${dotenv.env['API_URL']}/auth/login',
            data: {
              "email": emailController.text,
              "password": passwordController.text
            },
          );
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
            prefs.setString('email', emailController.text);
            prefs.setString('password', passwordController.text);
            try {
              // prefs.setInt('exp', u.exp!);
              prefs.setInt('level', u.level!);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                  showCloseIcon: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                  content: Text(
                    'Error $e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
            Navigator.pushReplacementNamed(context, '/navbar');
          } else if (response.statusCode == 220) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                showCloseIcon: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Text(
                  'Disabled account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (response.statusCode == 221) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                showCloseIcon: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Text(
                  'Account not found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (response.statusCode == 222) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                showCloseIcon: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Text(
                  'Wrong credentials. Try again with other values',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                showCloseIcon: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Text(
                  'Wrong credentials. Try again with other values',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 222, 66, 66),
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'Wrong credentials. Try again with other values',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 222, 66, 66),
            showCloseIcon: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
            content: const Text(
              'Empty credentials. Please, try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
            content: const Text(
              'Tap back again to leave',
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 850)),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: 1080,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          // Logo
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 47.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  Theme.of(context).brightness ==
                                          Brightness.light
                                      ? 'images/light_image.png'
                                      : 'images/dark_image.png',
                                  height: 185,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Email address textfield
                          CredentialTextField(
                            controller: emailController,
                            labelText: AppLocalizations.of(context)!.email,
                            obscureText: false,
                          ),

                          const SizedBox(height: 10),

                          // Password textfield
                          PasswordTextField(
                            controller: passwordController,
                            labelText: AppLocalizations.of(context)!.pass,
                            obscureText: true,
                          ),

                          const SizedBox(height: 20),

                          // Log in button
                          CredentialButton(
                            buttonText: AppLocalizations.of(context)!.login,
                            onTap: logIn,
                          ),

                          const SizedBox(height: 20),

                          // Or continue with
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    AppLocalizations.of(context)!.continuewith,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Google
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GestureDetector(
                          onTap: () => AuthService().signInWithGoogle(context),
                          child: Image.asset(
                            'images/google.png',
                            height: 65,
                          ),
                        ),
                      ),
                    ),

                    // Don't have an account?
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dont_have_account,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register_screen');
                          },
                          child: Text(
                            AppLocalizations.of(context)!.signin,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 222, 66, 66),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
