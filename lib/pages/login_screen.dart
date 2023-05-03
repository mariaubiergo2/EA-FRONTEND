import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/pages/register_screen.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
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
                  style: TextStyle(fontFamily: 'NerkoOne', fontSize: 50.0)
              ),
              const Divider(
                height: 30,
              ),
              const SizedBox(
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
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                enableInteractiveSelection: true,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Write your password...',
                    suffixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                onSubmitted: (valor) {
                  _password = valor;
                  print('El password es $_password');
                },
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              const Text("Are you a new user? Create an account!",
                style: TextStyle(fontFamily: 'NerkoOne', fontSize: 18.0),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: Color.fromRGBO(0, 115, 216, 0.988),
                        shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.all(13.0),
                        textStyle: const TextStyle(
                          fontFamily: 'NerkoOne',
                          fontSize: 20.0,
                        )),
                          onPressed: (){
                          Navigator.pushNamed(context, '/register_screen');
                          },
                          child: const Text("Register",
                            style: TextStyle(fontFamily: 'NerkoOne', fontSize: 20.0),),
                          ))
              ],
            )
          ]),
    );
  }
}
