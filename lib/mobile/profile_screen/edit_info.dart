// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:ea_frontend/mobile/credential_screen/login_screen.dart';
import 'package:ea_frontend/mobile/navbar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/credential_screen/credential_button.dart';
import 'package:ea_frontend/widget/credential_screen/credential_textfield.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await dotenv.load();
}

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final usernameController = TextEditingController();
  final textController = TextEditingController();
  bool _isStrong = false;

  String? _token = "";
  String? _idUser = "";
  String? _name = "";
  String? _surname = "";
  String? _username = "";

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
      _name = prefs.getString('name');
      _surname = prefs.getString('surname');
      _username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    void editAccount() async {
      try {
        if ((nameController.text == '') &&
            (surnameController.text == '') &&
            (usernameController.text == '')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 222, 66, 66),
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'All fields are empty',
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
          String namePlaceHolder, surnamePlaceHolder, usernamePlaceHolder;
          if (nameController.text != '') {
            namePlaceHolder = nameController.text;
          } else {
            namePlaceHolder = _name ?? '';
          }
          if (surnameController.text != '') {
            surnamePlaceHolder = surnameController.text;
          } else {
            surnamePlaceHolder = _surname ?? '';
          }
          if (usernameController.text != '') {
            usernamePlaceHolder = usernameController.text;
          } else {
            usernamePlaceHolder = _username ?? '';
          }
          final prefs = await SharedPreferences.getInstance();
          final String token = prefs.getString('token') ?? "";
          String path = 'http://${dotenv.env['API_URL']}/user/update/$_idUser';

          var response = await Dio().post(
            path,
            data: {
              "name": namePlaceHolder,
              "surname": surnamePlaceHolder,
              "username": usernamePlaceHolder,
            },
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token",
              },
            ),
          );

          if (response.statusCode == 200) {
            prefs.setString("name", namePlaceHolder);
            prefs.setString("username", usernamePlaceHolder);
            prefs.setString("surname", surnamePlaceHolder);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: Row(
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

            // auth.signOut();
            // GoogleSignIn().signOut();
            // clearInfo();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: const NavBar()));
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
                                    const EdgeInsets.fromLTRB(10, 0, 10, 35),
                                child: Column(
                                  children: [
                                    //Name textfield
                                    CredentialTextField(
                                        controller: nameController,
                                        labelText: "$_name",
                                        obscureText: false),

                                    const SizedBox(height: 10),

                                    //Surname textfield
                                    CredentialTextField(
                                        controller: surnameController,
                                        labelText: "$_surname",
                                        obscureText: false),

                                    const SizedBox(height: 10),

                                    //Username textfield
                                    CredentialTextField(
                                        controller: usernameController,
                                        labelText: "$_username",
                                        obscureText: false),

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
