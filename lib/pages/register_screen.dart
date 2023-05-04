import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 156, 216, 242),
      appBar: AppBar(
          title: Text('REGISTER'),
          shadowColor: Color.fromRGBO(0, 0, 128, 4),
          backgroundColor: Color.fromRGBO(0, 0, 128, 4)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 90.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                validator: (value) {
                  if (value == "" || value == null) {
                    return 'Please introduce your name';
                  }
                  return null;
                },
              ),
              const Divider(
                height: 18.0,
              ),
              TextFormField(
                controller: surnameController,
                decoration: InputDecoration(
                    labelText: 'Surname',
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
              const Divider(
                height: 18.0,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
              const Divider(
                height: 18.0,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
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
              const Divider(
                height: 18.0,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(0, 0, 128, 4),
                      textStyle: const TextStyle(
                        fontFamily: 'NerkoOne',
                        fontSize: 30.0,
                      )),
                  onPressed: () async {
                    var response = await Dio()
                        .post("http://127.0.0.1:3002/auth/register", data: {
                      // .post("http://192.168.56.1:3002/auth/register", data: {
                      "name": nameController.text,
                      "surname": surnameController.text,
                      "email": emailController.text,
                      "password": passwordController.text
                    });
                    if (response.statusCode == 200) {
                      Navigator.pushNamed(context, '/login_screen');
                    } else {
                      print("Drama");
                    }
                  },
                  child: const Text('REGISTER'),
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
