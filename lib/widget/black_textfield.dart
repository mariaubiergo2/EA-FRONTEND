import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlackTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText; 
  final IconData icon;

  const BlackTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    required this.icon,
  }) : super(key: key);
  
  @override
  _BlackTextFieldState createState() => _BlackTextFieldState();
}

class _BlackTextFieldState extends State<BlackTextField> {
      
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        cursorColor: Color.fromARGB(255, 222, 66, 66),
        style: TextStyle(color: Color.fromARGB(255, 239, 239, 239), fontSize: 17),
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 25),
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Color.fromARGB(255, 222, 66, 66), fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Color.fromARGB(255, 25, 25, 25),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 222, 66, 66), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(20)),),
          suffixIcon: 
          
          Icon(widget.icon, color: Color.fromARGB(255, 222, 66, 66),),
        //Icons.lock_outline
        //Icons.email
        ),
      );
  }
}