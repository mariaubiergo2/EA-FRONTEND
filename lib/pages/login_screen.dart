import 'package:ea_frontend/widget/log_in_button.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/widget/black_textfield_email.dart';
import 'package:ea_frontend/widget/black_textfield_password.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 207, 5),
      body: SafeArea(
          child: Center(
              child: Column(children: [
        SizedBox(height: 75),

        //Label with Hello!

        Text(
          'Hello!',
          style: TextStyle(fontSize: 75, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 140),

        //Email address textfield

        BlackTextFieldEmail(),
        SizedBox(height: 25),

        //Password textfield

        BlackTextFieldPassword(),
        SizedBox(height: 35),

        //Log in button

        LogInButton(),
        SizedBox(height: 35),

        //Or continue with

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 25, 25, 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Or continue with',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 25, 25, 25),
                ),
              ),
            ],
          ),
        ),

        //Google

        //Don't have an account?
        SizedBox(height: 130),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(width: 4),
            Text(
              "Sign Up",
              style: TextStyle(
                  color: Color.fromARGB(255, 222, 66, 66),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ],
        ),
      ]))),
    );
  }
}
