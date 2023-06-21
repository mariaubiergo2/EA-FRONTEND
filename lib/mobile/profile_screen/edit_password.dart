// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:ea_frontend/mobile/credential_screen/login_screen.dart';
import 'package:ea_frontend/mobile/navbar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widget/credential_screen/credential_button.dart';
import 'package:ea_frontend/widget/credential_screen/password_textfield.dart';
import 'package:ea_frontend/widget/credential_screen/credential_textfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await dotenv.load();
}

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final usernameController = TextEditingController();
  final previouspassController = TextEditingController();
  final passwordController = TextEditingController();
  final passControllerVerify = TextEditingController();
  final textController = TextEditingController();
  bool _isStrong = false;

  String? _token = "";
  String? _idUser = "";
  String? _password = "";

  double strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Aa-z].*");
  late String password;
  String text = "";
  Color colorPasswordIndicator = Colors.black;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;

    getUserInfo();
  }

  Future clearInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _idUser = prefs.getString('idUser');
      _password = prefs.getString('password');
    });
  }

  @override
  Widget build(BuildContext context) {
    void editAccount() async {
      try {
        if ((previouspassController.text == '') ||
            (passwordController.text == '') ||
            (passControllerVerify.text == '')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 222, 66, 66),
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'Check that there are no empty fields',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (!_isStrong) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'The new password is not strong enough',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              closeIconColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (passControllerVerify.text != passwordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'New password don\'t match',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              closeIconColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (previouspassController.text != _password) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'Check that you have entered your current password correctly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              closeIconColor: Colors.black,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          final prefs = await SharedPreferences.getInstance();
          final String token = prefs.getString('token') ?? "";
          String path = 'http://${dotenv.env['API_URL']}/user/update/$_idUser';

          var response = await Dio().post(
            path,
            data: {
              "password": passwordController.text,
            },
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token",
              },
            ),
          );

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Account successfully edited',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );

            auth.signOut();
            GoogleSignIn().signOut();
            clearInfo();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const LoginScreen()));
          } else if (response.statusCode == 400) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                showCloseIcon: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Text(
                  'Check that there are valid values',
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color.fromARGB(255, 222, 66, 66),
            showCloseIcon: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
            content: const Text(
              'Unable to edit the account. Try again later',
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

    void checkPassword(String value) {
      password = value.trim();

      if (password.isEmpty) {
        setState(() {
          strength = 0;
          text = AppLocalizations.of(context)!.enterpass;
        });
      } else if (password.length < 4) {
        setState(() {
          strength = 1 / 5;
          colorPasswordIndicator = const Color.fromARGB(255, 222, 66, 66);
          text = AppLocalizations.of(context)!.shortpass;
        });
      } else if (password.length < 6) {
        setState(() {
          strength = 2 / 4;
          colorPasswordIndicator = Colors.orange;
          text = AppLocalizations.of(context)!.charpass;
        });
      } else {
        if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
          setState(() {
            strength = 3 / 4;
            colorPasswordIndicator = Colors.amber;
            text = AppLocalizations.of(context)!.numpass;
          });
        } else {
          setState(() {
            strength = 1;
            colorPasswordIndicator = Colors.green;
            text = AppLocalizations.of(context)!.greatpass;
            _isStrong = true;
          });
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 0, 25),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: const NavBar()));
                      },
                      backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 1080,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 27.5),
                                child: Column(
                                  children: [
                                    //Previous password textfield
                                    CredentialTextField(
                                        controller: previouspassController,
                                        labelText: "Escriba su contraseña",
                                        obscureText: false),

                                    const SizedBox(height: 10),

                                    //Password textfield
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: TextField(
                                        onChanged: (val) => checkPassword(val),
                                        controller: passwordController,
                                        obscureText: passwordVisible,
                                        cursorColor: const Color.fromARGB(
                                            255, 222, 66, 66),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.color,
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0),
                                            child: IconButton(
                                              icon: Icon(
                                                  passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: const Color.fromARGB(
                                                      255, 222, 66, 66)),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    passwordVisible =
                                                        !passwordVisible;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  25, 25, 25, 25),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 222, 66, 66),
                                                width: 3),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          labelText:
                                              "Escriba la nueva contraseña",
                                          labelStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 146, 146, 146),
                                              fontSize: 17),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          fillColor: const Color.fromARGB(
                                              255, 242, 242, 242),
                                          filled: true,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        //borderRadius: BorderRadius.circular(  10.0), // Establece el radio de los bordes
                                        child: SizedBox(
                                          height:
                                              4.0, // Ajusta la altura del indicador de progreso según sea necesario
                                          child: LinearProgressIndicator(
                                            value: strength,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 146, 146, 146),
                                            color: colorPasswordIndicator,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      AppLocalizations.of(context)!.enterpass,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontSize: 14),
                                    ),

                                    const SizedBox(height: 5),

                                    //Password textfield
                                    PasswordTextField(
                                        controller: passControllerVerify,
                                        labelText: "Repita la nueva contraseña",
                                        obscureText: true),

                                    const SizedBox(height: 30),

                                    //Sign up button
                                    CredentialButton(
                                      buttonText: "EDITAR",
                                      onTap: editAccount,
                                    ),

                                    const SizedBox(height: 5),

                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        "Una vez haya realizado los cambios, deberá iniciar sesión de nuevo",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
