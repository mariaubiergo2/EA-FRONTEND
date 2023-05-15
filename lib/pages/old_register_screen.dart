import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:email_validator/email_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isChecked = false;
  final passControllerVerify = TextEditingController();
  bool mailIsValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Write your name...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                    hintText: 'Surname',
                    labelText: 'Write your surname...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: 'Username',
                    labelText: 'Write your username...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Write your email...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == "") {
                    return 'Please introduce your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Write your password...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please introduce a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passControllerVerify,
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Please confirm your password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                obscureText: true,
                validator: (value) {
                  if (value == "" || value != passwordController.text) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  Text(
                    'Accept the privacy policy',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      backgroundColor: Color.fromRGBO(0, 115, 216, 0.988),
                      shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(13.0),
                      textStyle: const TextStyle(
                        fontFamily: 'NerkoOne',
                        fontSize: 20.0,
                      )),
                  onPressed: () async {
                    if (!_isChecked) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Unable!',
                          message: 'Accept the privacy policy',
                          contentType: ContentType.failure,
                        ),
                      ));
                    } else {
                      try {
                        mailIsValid =
                            EmailValidator.validate(emailController.text);
                        if (passControllerVerify.text !=
                                passwordController.text &&
                            passwordController.text != "") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            /// need to set following properties for best effect of awesome_snackbar_content
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Unable!',
                              message: 'Passwords don\'t match',

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.failure,
                            ),
                          ));
                        } else if (!mailIsValid) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            /// need to set following properties for best effect of awesome_snackbar_content
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Unable!',
                              message: 'Check your mail 👉👈',

                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                              contentType: ContentType.failure,
                            ),
                          ));
                        } else {
                          var response = await Dio().post(
                              "http://127.0.0.1:3002/auth/register",
                              data: {
                                "name": nameController.text,
                                "surname": surnameController.text,
                                "username": usernameController.text,
                                "email": emailController.text,
                                "password": passwordController.text,
                                "passwordVerify": passControllerVerify.text
                                // "password": await DBCrypt()
                                //     .hashpw(passwordController.text, salt),
                              });
                          print(
                              "Error debug: " + response.statusCode.toString());
                          if (response.statusCode == 200) {
                            Navigator.pushNamed(context, '/login_screen');
                          }
                          if (response.statusCode == 400) {
                            print(response.statusMessage);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              /// need to set following properties for best effect of awesome_snackbar_content
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Unable!',
                                message: 'Drama pau',

                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                contentType: ContentType.failure,
                              ),
                            ));
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Unable!',
                            message: 'Please, try other values',

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.failure,
                          ),
                        ));
                      }
                    }
                  },
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future register(
      String name, String surname, String email, String password) async {
    var response = await Dio().post("http://192.168.56.1:3002/auth/login",
        data: {
          "name": name,
          "surname": surname,
          "email": email,
          "password": password
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.red;
}
