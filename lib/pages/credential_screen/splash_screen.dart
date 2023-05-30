// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/user.dart';

void main() async {
  await dotenv.load();
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("idUser");
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");
    if (username == null) {
      Navigator.pushNamed(context, '/login_screen');
    } else {
      var response = await Dio().post(
          'http://${dotenv.env['API_URL']}/auth/login',
          data: {"email": email, "password": password});
      Map<String, dynamic> payload = Jwt.parseJwt(response.toString());
      User u = User.fromJson(payload);
      var data = json.decode(response.toString());
      prefs.setString('token', data['token']);
      prefs.setString('idUser', u.idUser);
      prefs.setString('name', u.name);
      prefs.setString('surname', u.surname);
      prefs.setString('username', u.username);
      Navigator.pushNamed(context, '/navbar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 25, 25, 25), // Agregue el color de fondo aquí
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
              child: Column(
                children: [
                  Image.asset(
                    'images/logo_splash.png',
                    height: 225,
                  ),
                ],
              ),
            ),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 222, 66, 66))),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
