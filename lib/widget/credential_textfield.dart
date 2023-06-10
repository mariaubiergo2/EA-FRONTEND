// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CredentialTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String)? function;

  const CredentialTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.function,
  }) : super(key: key);

  @override
  _CredentialTextFieldState createState() => _CredentialTextFieldState();
}

class _CredentialTextFieldState extends State<CredentialTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        cursorColor: const Color.fromARGB(255, 222, 66, 66),
        style: const TextStyle(
            color: Color.fromARGB(255, 67, 67, 67), fontSize: 17),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 222, 66, 66), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 146, 146, 146), fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color.fromARGB(255, 242, 242, 242),
          filled: true,
        ),
      ),
    );
  }
}
