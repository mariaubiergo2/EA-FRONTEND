import 'package:flutter/material.dart';

import 'navbar.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('EETAC -  GO'),
      ),
    );
  }
}
