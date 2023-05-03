import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/pages/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String idUser = "";
  late String _nombre;
  late String _email;
  late String _password;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  Widget inputField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: TextField(
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('images/logo.png'),
                ),
                const Text('EETACgo',
                    style: TextStyle(fontFamily: 'NerkoOne', fontSize: 50.0)),
                const Divider(
                  height: 30,
                ),
                const SizedBox(
                  width: 160.0,
                  height: 15.0,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Write your email...',
                      suffixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onSubmitted: (valor) {
                    _email = valor;
                    print('El email es $_email');
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  enableInteractiveSelection: true,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      suffixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  onSubmitted: (valor) {
                    _password = valor;
                    print('El password es $_password');
                  },
                ),
                SizedBox(height: 15),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                          backgroundColor: Color.fromRGBO(0, 115, 216, 0.988),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(30.0)),
                          padding: EdgeInsets.all(16.0),
                          textStyle: const TextStyle(
                            fontFamily: 'NerkoOne',
                            fontSize: 30.0,
                          )),
                      onPressed: () async {
                        try {
                          var response = await Dio().post(
                              "http://127.0.0.1:3002/auth/login",
                              // "http://192.168.56.1:3002/auth/login",
                              data: {
                                "email": emailController.text,
                                "password": passwordController.text
                              });
                          if (response.statusCode == 200) {
                            Navigator.pushNamed(context, '/list_screen');
                            //final idUserSaved=Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return new ListScreen(idUser);}));
                          } else if (response.statusCode == 403) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Wrong credentials!'),
                              ),
                            );
                          }
                        } catch (e) {
                          print("Error" + e.toString());
                        }
                      },
                      child: const Text('Log in'),
                    )),
                SizedBox(height: 20),
                Text(
                  "Are you a new user? Create an account!",
                  style: TextStyle(fontFamily: 'NerkoOne', fontSize: 20.0),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register_screen');
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(0, 0, 128, 4))),
                  child: Text(
                    "Register",
                    style: TextStyle(fontFamily: 'NerkoOne', fontSize: 20.0),
                  ),
                )
              ],
            )
          ]),
    );
  }
}
