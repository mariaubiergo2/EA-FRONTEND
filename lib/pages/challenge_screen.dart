// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class challenge_screen extends StatefulWidget {
  const challenge_screen({super.key});

  @override
  State<challenge_screen> createState() => _challenge_screenState();
}

class _challenge_screenState extends State<challenge_screen> {
  String? _idUser = "";
  String? _name = "";
  String? _surname = "";
  String? _username = "";
  String? _token = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _idUser = prefs.getString('idUser');
      _name = prefs.getString('name');
      _surname = prefs.getString('surname');
      _username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
    );
  }
}
