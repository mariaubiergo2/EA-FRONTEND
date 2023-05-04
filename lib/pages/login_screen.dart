import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/pages/register_screen.dart';
import 'package:ea_frontend/pages/initial_screen.dart';
import 'package:lit_starfield/lit_starfield.dart';

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
      //EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
      body: Stack(      
        children: [         
          LitStarfieldContainer(
            animated: true,
            number: 500,
            velocity: 0.85,
            depth: 0.9,
            scale: 4,
            starColor: Color.fromARGB(255, 255, 197, 7),
            backgroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF031936),
                  Color.fromRGBO(3,10, 90, 6),
                  //Color.fromARGB(255, 108, 87, 16),
                  Color.fromARGB(255, 11, 7, 255),
                  
                  Color(0xFF031936),
                  Color.fromARGB(255, 156, 102, 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/logo.png'),
              ),
              const Text('EETACgo',
                  style: TextStyle(fontFamily: 'NerkoOne', fontSize: 50.0, color: Color.fromRGBO(255, 255, 255, 1))
              ),
              const Divider(
                height: 30,
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                style: TextStyle(fontFamily: 'NerkoOne', fontSize: 16.0, color: Color.fromRGBO(255, 255, 255, 1)),
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
                style: TextStyle(fontFamily: 'NerkoOne', fontSize: 16.0, color: Color.fromRGBO(255, 255, 255, 1)),
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
                          color: Color.fromRGBO(255, 255, 255, 1),
                        )),
                    onPressed: () async {
                      try {
                        var response = await Dio().post(
                            "http://127.0.0.1:3002/user/token",
                            // "http://192.168.56.1:3002/auth/login",
                            data: {
                              "email": emailController.text,
                              "password": passwordController.text
                            });
                        if (response.statusCode == 200) {
                          Navigator.pushNamed(context, '/initial_screen');
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
                style: TextStyle(fontFamily: 'NerkoOne', fontSize: 18.0, color:Color.fromRGBO(255, 255, 255, 1)),
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
                          )),
              ],
            )
    )]),
    );
        
  }
}
