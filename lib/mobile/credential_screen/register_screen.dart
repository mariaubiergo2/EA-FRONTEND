// ignore_for_file: use_build_context_synchronously

import 'package:ea_frontend/widget/credential_screen/password_textfield.dart';
import 'package:ea_frontend/widget/credential_screen/credential_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../widget/credential_screen/credential_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await dotenv.load();
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passControllerVerify = TextEditingController();
  final textController = TextEditingController();
  bool _isChecked = false;
  bool _isStrong = false;

  double strength = 0;
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Aa-z].*");
  late String password;
  String text = "";
  Color colorPasswordIndicator = Colors.black;

  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    //Sign up method
    void signUp() async {
      try {
        if ((nameController.text == '') ||
            (surnameController.text == '') ||
            (usernameController.text == '') ||
            (emailController.text == '') ||
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
        } else if (!EmailValidator.validate(emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'Invalid email address',
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
        } else if (!_isStrong) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'The password is not strong enough',
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
                'Passwords don\'t match',
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
        } else if (!_isChecked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.amber,
              showCloseIcon: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
              content: const Text(
                'The terms of use and privacy policy must be accepted',
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
          var response = await Dio()
              .post("http://${dotenv.env['API_URL']}/auth/register", data: {
            "name": nameController.text,
            "surname": surnameController.text,
            "username": usernameController.text,
            "email": emailController.text,
            "password": passwordController.text,
          });
          if (response.statusCode == 200) {
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
                        'Account successfully created',
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

            Navigator.pushNamed(context, '/login_screen');
          } else if (response.statusCode == 220) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                showCloseIcon: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
                content: const Text(
                  'Email address not available. Try another one',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
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
              'Unable to create an account. Try again later',
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1080,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),

                            //Name textfield
                            CredentialTextField(
                                controller: nameController,
                                labelText: AppLocalizations.of(context)!.name,
                                obscureText: false),

                            const SizedBox(height: 10),

                            //Surname textfield
                            CredentialTextField(
                                controller: surnameController,
                                labelText:
                                    AppLocalizations.of(context)!.surname,
                                obscureText: false),

                            const SizedBox(height: 10),

                            //Username textfield
                            CredentialTextField(
                                controller: usernameController,
                                labelText:
                                    AppLocalizations.of(context)!.username,
                                obscureText: false),

                            const SizedBox(height: 10),

                            //Email address textfield
                            CredentialTextField(
                                controller: emailController,
                                labelText: AppLocalizations.of(context)!.email2,
                                obscureText: false),

                            const SizedBox(height: 10),

                            //Password textfield
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                                onChanged: (val) => checkPassword(val),
                                controller: passwordController,
                                obscureText: passwordVisible,
                                cursorColor:
                                    const Color.fromARGB(255, 222, 66, 66),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        ?.color,
                                    fontSize: 17),
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
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
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 25, 25, 25),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 222, 66, 66),
                                        width: 3),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.pass2,
                                  labelStyle: const TextStyle(
                                      color: Color.fromARGB(255, 146, 146, 146),
                                      fontSize: 17),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor:
                                      const Color.fromARGB(255, 242, 242, 242),
                                  filled: true,
                                ),
                              ),
                            ),

                            const SizedBox(height: 2),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                //borderRadius: BorderRadius.circular(  10.0), // Establece el radio de los bordes
                                child: SizedBox(
                                  height:
                                      4.0, // Ajusta la altura del indicador de progreso según sea necesario
                                  child: LinearProgressIndicator(
                                    value: strength,
                                    backgroundColor: const Color.fromARGB(
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
                                labelText: AppLocalizations.of(context)!.pass22,
                                obscureText: true),

                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    side: BorderSide(
                                        color: Theme.of(context).dividerColor),
                                    checkColor: const Color.fromARGB(
                                        255, 242, 242, 242),
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
                                Text(
                                  AppLocalizations.of(context)!.i_accept,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              AppLocalizations.of(context)!
                                                  .terms),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  style: TextStyle(
                                                    fontSize: 13.5,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        ?.color,
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                  AppLocalizations.of(context)!
                                                      .gigaterms,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                overlayColor: MaterialStateColor
                                                    .resolveWith(
                                                  (states) =>
                                                      const Color.fromARGB(
                                                              255, 222, 66, 66)
                                                          .withOpacity(0.2),
                                                ),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .close,
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 222, 66, 66),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.terms,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            //Sign up button
                            CredentialButton(
                              buttonText: AppLocalizations.of(context)!.signup,
                              onTap: signUp,
                            ),

                            //Already have an account?
                            const SizedBox(height: 33),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.have_account,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontSize: 17),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/login_screen');
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.login2,
                                    style: const TextStyle(
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
      ),
    );
  }
}
