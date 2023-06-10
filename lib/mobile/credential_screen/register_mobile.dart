// ignore_for_file: use_build_context_synchronously

import 'package:ea_frontend/widget/credential_screen/password_textfield.dart';
import 'package:ea_frontend/widget/credential_screen/credential_textfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../widget/credential_screen/credential_button.dart';

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
  String text = "Please enter a password";
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Attention!',
              message: 'Check that there are no empty fields.',
              contentType: ContentType.failure,
            ),
          ));
        } else if (!EmailValidator.validate(emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Attention!',
              message: 'Invalid email address.',
              contentType: ContentType.failure,
            ),
          ));
        } else if (!_isStrong) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Attention!',
              message: 'The password is not strong enough.',
              contentType: ContentType.failure,
            ),
          ));
        } else if (passControllerVerify.text != passwordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Attention!',
              message: 'Passwords don\'t match.',
              contentType: ContentType.failure,
            ),
          ));
        } else if (!_isChecked) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Attention!',
              message: 'The terms of use and privacy policy must be accepted.',
              contentType: ContentType.failure,
            ),
          ));
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
            Navigator.pushNamed(context, '/login_screen');
          }
          if (response.statusCode == 400) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Unable!',
                message: 'Check that there are valid values.',
                contentType: ContentType.failure,
              ),
            ));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Unable!',
            message: 'Unable to create an account. Try again later.',
            contentType: ContentType.failure,
          ),
        ));
      }
    }

    void checkPassword(String value) {
      password = value.trim();

      if (password.isEmpty) {
        setState(() {
          strength = 0;
          text = "Please enter a password";
        });
      } else if (password.length < 4) {
        setState(() {
          strength = 1 / 5;
          colorPasswordIndicator = const Color.fromARGB(255, 222, 66, 66);
          text = "Your password is too short";
        });
      } else if (password.length < 6) {
        setState(() {
          strength = 2 / 4;
          colorPasswordIndicator = Colors.orange;
          text = "Your password should have at least 6 characters";
        });
      } else {
        if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
          setState(() {
            strength = 3 / 4;
            colorPasswordIndicator = Colors.amber;
            text = "Your password should contain at least one number";
          });
        } else {
          setState(() {
            strength = 1;
            colorPasswordIndicator = Colors.green;
            text = "Your password is great!";
            _isStrong = true;
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1080,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),

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
                                obscureText: false),

                            const SizedBox(height: 10),

                            //Username textfield
                            CredentialTextField(
                                controller: usernameController,
                                labelText: "Username",
                                obscureText: false),

                            const SizedBox(height: 10),

                            //Email address textfield
                            CredentialTextField(
                                controller: emailController,
                                labelText: "Email address",
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
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 67, 67, 67),
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
                                  labelText: "Password",
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
                              text,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 242, 242, 242),
                                  fontSize: 14),
                            ),

                            const SizedBox(height: 5),

                            //Password textfield
                            PasswordTextField(
                                controller: passControllerVerify,
                                labelText: "Repeat your password",
                                obscureText: true),

                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 242, 242, 242)),
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
                                const Text(
                                  'I accept the ',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 242, 242, 242),
                                      fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              'Terms of use and Privacy Policy'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: const [
                                                Text(
                                                  style:
                                                      TextStyle(fontSize: 13.5),
                                                  textAlign: TextAlign.justify,
                                                  '''
Acceptance of Terms: By accessing and using this app/service, you agree to be bound by these Terms of Use.

User Responsibilities: You are responsible for the proper use of the app/service and complying with any applicable laws and regulations.

Intellectual Property: All content and materials provided by the app/service are protected by intellectual property laws and remain the property of the app/service owner.

Limitation of Liability: The app/service owner is not liable for any damages or losses incurred while using the app/service.

Termination: The app/service owner reserves the right to terminate or suspend your access to the app/service at any time without prior notice.

Information Collection: We may collect personal information, such as name and email address, for the purpose of providing and improving the app/service.

Information Usage: We use the collected information to personalize your experience, send updates, and analyze app/service usage patterns.

Data Sharing: We do not sell or disclose your personal information to third parties, except in cases required by law or with your consent.

Data Security: We implement reasonable security measures to protect your personal information from unauthorized access, alteration, or disclosure.

Cookies: The app/service may use cookies or similar technologies to enhance user experience and collect usage data.

Third-Party Links: The app/service may contain links to third-party websites or services, which have their own privacy practices. We are not responsible for the privacy practices or content of these third parties.

Updates to Privacy Policy: We may update the Privacy Policy from time to time, and it is your responsibility to review it periodically.

''',
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
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
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
                                  child: const Text(
                                      "Terms of use and Privacy Policy",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 242, 242, 242),
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            //Sign up button
                            CredentialButton(
                              buttonText: "SIGN UP",
                              onTap: signUp,
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
                                    Navigator.pushNamed(
                                        context, '/login_screen');
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
      ),
    );
  }
}
