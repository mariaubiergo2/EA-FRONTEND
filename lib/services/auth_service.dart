// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:ea_frontend/mobile/navbar_mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/user.dart' as user_ea;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  Future<void> logIn(User user) async {
    try {
      var response = await Dio().post(
          "http://${dotenv.env['API_URL']}/auth/login",
          data: {"email": user.email, "password": user.uid});
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> payload = Jwt.parseJwt(response.toString());

        print('Token:' + payload.toString());

        user_ea.User u = user_ea.User.fromJson(payload);
        var data = json.decode(response.toString());

        print(data['token']);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('idUser', u.idUser);
        prefs.setString('name', u.name);
        prefs.setString('surname', u.surname);
        prefs.setString('username', u.username);
      } else {
        print('Error, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error login user: $e');
    }
  }

  Future<bool> SignInViaGoogle(User user) async {
    try {
      var response = await Dio()
          .post("http://${dotenv.env['API_URL']}/auth/loginGAuth", data: {
        "name": user.displayName,
        "surname": user.displayName,
        "username": user.displayName,
        "email": user.email,
        "password": user.uid
      });
      print(response);

      if (response.statusCode == 200) {
        print('User registration successful');
        Map<String, dynamic> payload = Jwt.parseJwt(response.toString());

        print('Token:' + payload.toString());

        user_ea.User u = user_ea.User.fromJson(payload);
        var data = json.decode(response.toString());

        print(data['token']);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('idUser', u.idUser);
        prefs.setString('name', u.name);
        prefs.setString('surname', u.surname);
        prefs.setString('username', u.username);
        return true;
      } else {
        print(
            'User registration failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // SignIn with Google
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // Empezamos el logIn con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtenemos los detalles de la request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Obtenemos las credenciales del AuthProvider
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Hacemos SignIn con los credenciales que nos da google
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      print('-------------User logged in via Google Auth-------------');
      // Print user info
      print('User ID: ${user?.uid}');
      print('Display Name: ${user?.displayName}');
      print('Email: ${user?.email}');

      //Intentamos login en API
      final bool registerOK = await SignInViaGoogle(user!);
      if (registerOK) {
        Navigator.pushNamed(context, '/navbar');
      }

      return userCredential;
    } catch (e) {
      print('Sign-in with Google failed: $e');
      return null;
    }
  }
}

// class AuthService {
// //SignIn con Google
//   signInWithGoogle() async {
//     //Begin intercative sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//     //Obtain auth details from request
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//     //Create new credentials for user
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//     //Finally sign in
//     print(FirebaseAuth.instance.signInWithCredential(credential));
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
  
// }
