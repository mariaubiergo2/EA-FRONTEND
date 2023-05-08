import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {
  const LogInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 25, 25, 25), width: 3),
          color: const Color.fromARGB(255, 222, 66, 66),
          borderRadius: BorderRadius.circular(20)),
      child: const Center(
        child: Text(
          "LOG IN",
          style: TextStyle(
            color: Color.fromARGB(255, 25, 25, 25),
            fontWeight: FontWeight.w900,
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
