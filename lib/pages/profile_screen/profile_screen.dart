// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1080,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          100.0), // Ajusta el radio según tus necesidades
                      child: Image.asset(
                        'images/example.png',
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      '$_name $_surname',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 242, 242, 242),
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$_username',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 242, 242, 242),
                          fontSize: 13),
                    ),
                    const SizedBox(height: 30),
                    const Divider(
                      color: Color.fromARGB(255, 52, 52, 52),
                      height: 0.05,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Following",
                          style: TextStyle(
                              color: Color.fromARGB(255, 242, 242, 242),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(width: 100),
                        Text(
                          "Followers",
                          style: TextStyle(
                              color: Color.fromARGB(255, 242, 242, 242),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Color.fromARGB(255, 52, 52, 52),
                      height: 0.05,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 222, 66, 66),
                              ),
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Edit accotunt",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 242, 242, 242),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 222, 66, 66),
                              ),
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Information",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 242, 242, 242),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 222, 66, 66),
                              ),
                            ),
                            const SizedBox(width: 25),
                            const Text(
                              "Delete account",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 242, 242, 242),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          ]),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
