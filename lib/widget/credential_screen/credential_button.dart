import 'package:flutter/material.dart';

class CredentialButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;

  const CredentialButton(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 242, 242, 242), width: 3),
            color: const Color.fromARGB(255, 222, 66, 66),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Color.fromARGB(255, 242, 242, 242),
              fontWeight: FontWeight.w900,
              fontSize: 19,
            ),
          ),
        ),
      ),
    );
  }
}
