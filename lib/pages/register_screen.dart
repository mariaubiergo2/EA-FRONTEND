import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:ea_frontend/widget/credential_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../widget/credential_button.dart';

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
    //Sign up method
    void SignUp() {}

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
                          const SizedBox(height: 40),

                          //Hello
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'images/hello.png',
                                height: 57,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          //Name textfield
                          CredentialTextField(
                              controller: nameController,
                              labelText: "Name",
                              obscureText: false),

                          const SizedBox(height: 10),

                          //Surname textfield
                          CredentialTextField(
                              controller: surnameController,
                              labelText: "Surname",
                              obscureText: true),

                          const SizedBox(height: 10),

                          //Username textfield
                          CredentialTextField(
                              controller: usernameController,
                              labelText: "Username",
                              obscureText: true),

                          const SizedBox(height: 10),

                          //Email address textfield
                          CredentialTextField(
                              controller: emailController,
                              labelText: "Email address",
                              obscureText: true),

                          const SizedBox(height: 10),

                          //Password textfield
                          CredentialTextField(
                              controller: passwordController,
                              labelText: "Password",
                              obscureText: true),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 242, 242, 242)),
                                  checkColor:
                                      const Color.fromARGB(255, 242, 242, 242),
                                  activeColor:
                                      const Color.fromARGB(255, 222, 66, 66),
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              const Text(
                                'I accept the terms of use and Privacy Policy',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 242, 242, 242),
                                    fontSize: 14),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          //Sign up button
                          CredentialButton(
                            buttonText: "SIGN UP",
                            onTap: SignUp,
                          ),

                          //Already have an account?
                          const SizedBox(height: 33),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 242, 242, 242),
                                    fontSize: 17),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login_screen');
                                },
                                child: const Text(
                                  "Log In",
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
