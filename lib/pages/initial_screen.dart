import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class InitialScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 130, 164, 51),
      body: Center(
        child: 
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/login_screen');
            },
          ),
      ),
    );
  }
}
