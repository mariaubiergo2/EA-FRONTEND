import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String child;

  const MyCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          child,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
