import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final expController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
          title: Text('REGISTER'),
          shadowColor: Color.fromRGBO(0, 0, 128, 4),
          backgroundColor: Color.fromRGBO(0, 115, 216, 0.988)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Write your name...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                    hintText: 'Surname',
                    labelText: 'Write your surname...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: 'Username',
                    labelText: 'Write your username...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                    labelText: 'Write your email...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == "") {
                    return 'Please introduce your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Write your password...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == "") {
                    return 'Please introduce a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: expController,
                decoration: InputDecoration(
                    hintText: 'Experience',
                    labelText: 'Write your experience...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your experience';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                    var response = await Dio()
                        .post("http://127.0.0.1:3002/auth/register", data: {
                      // .post("http://192.168.56.1:3002/auth/register", data: {
                      "name": nameController.text,
                      "surname": surnameController.text,
                      "username": usernameController.text,
                      "email": emailController.text,
                      "password": passwordController.text,
                      "exp": int.parse(expController.text)
                    });
                    if (response.statusCode == 200) {
                      Navigator.pushNamed(context, '/login_screen');
                    } else {
                      print("Drama");
                    }
                  },
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future register(
      String name, String surname, String email, String password) async {
    var response = await Dio().post("http://192.168.56.1:3002/auth/login",
        data: {
          "name": name,
          "surname": surname,
          "email": email,
          "password": password
        });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
