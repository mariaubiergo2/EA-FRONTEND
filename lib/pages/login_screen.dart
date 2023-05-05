import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/pages/register_screen.dart';
import 'package:ea_frontend/pages/initial_screen.dart';
import 'package:lit_starfield/lit_starfield.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String idUser = "";
  late String _email;
  late String _password;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
      body: Stack(  
          children : <Widget>[                   
            const LitStarfieldContainer(
              animated: true,
              number: 500,
              velocity: 0.85,
              depth: 0.9,
              scale: 4,
              starColor: Color.fromARGB(255, 255, 247, 0),
              backgroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF031936),
                    Color.fromRGBO(9, 21, 155, 0.98),
                    //Color.fromARGB(255, 108, 87, 16),
                    //Color.fromARGB(255, 11, 7, 255),
                    //Color.fromARGB(255, 43, 46, 255),  
                    //Color.fromARGB(255, 209, 0, 146),  
                    //Color.fromARGB(255, 156, 102, 0),              
                    Color(0xFF031936),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0), 
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
                    style: const TextStyle(fontFamily: 'NerkoOne', fontSize: 16.0, color: Color.fromRGBO(255, 255, 255, 1)),
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Write your email...',
                        labelStyle: const TextStyle(color:Color.fromRGBO(255, 255, 255, 1)),
                        hintStyle: const TextStyle(color:Color.fromRGBO(0, 115, 216, 0.988),),
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
                    style: const TextStyle(fontFamily: 'NerkoOne', fontSize: 16.0, color: Color.fromRGBO(255, 255, 255, 1)),
                    controller: passwordController,
                    enableInteractiveSelection: true,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Write your password...',
                        labelStyle: const TextStyle(color:Color.fromRGBO(255, 255, 255, 1)),
                        hintStyle: const TextStyle(color:Color.fromRGBO(0, 115, 216, 0.988),),
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
                            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            backgroundColor: const Color.fromRGBO(0, 115, 216, 0.988),
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
                          if ((emailController.text!=' ') && (passwordController.text!=' ')){
                            try {
                              var response = await Dio().post(
                                  "http://127.0.0.1:3002/user/token",
                                  // "http://192.168.56.1:3002/auth/login",
                                  data: {
                                    "email": emailController.text,
                                    "password": passwordController.text
                                  });
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                Navigator.pushNamed(context, '/initial_screen');
                              } else {
                                print(response.statusCode);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Wrong credentials!',
                                      message:
                                          'Please, try again',
                                      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                      contentType: ContentType.failure,
                                    ),
                                  ));
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Wrong credentials!',
                                    message:
                                        'Please, try again',
                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.failure,
                                  ),
                                )
                              );
                                //   SnackBar(
                                //     behavior: SnackBarBehavior.floating,
                                //     backgroundColor: Colors.transparent,
                                //     elevation: 0,
                                //     content: Container(
                                //       padding: EdgeInsets.all(16),
                                //       height: 90,
                                //       decoration: BoxDecoration(
                                //         color: Colors.red,
                                //         borderRaColor.fromARGB(0, 137, 75, 75).all(Radius.circular(20)),
                                //       ),
                                //       child: Row(
                                //         children: [
                                //           const SizedBox(width: 40),
                                //           Expanded(
                                //             child: Column(  
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Text(
                                //                 'Wrong credentials!',
                                //                 style: TextStyle(fontSize: 18, color:Colors.white),
                                //                 ),
                                //               Text(
                                //                 'Error: '+e.toString(),
                                //                 style: TextStyle(fontSize: 12, color:Colors.white),
                                //                 maxLines: 2,
                                //                 overflow: TextOverflow.ellipsis,
                                //                 ),
                                //               ],
                                //               )
                                //         ),
                                //         ],
                                //       ),
                                //   ),
                                // ));
                            }
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
                            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            backgroundColor: const Color.fromRGBO(0, 115, 216, 0.988),
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
                              ),
                    ),
                ],
              )
  ),
  ]),
          );
    
        
  }
}
