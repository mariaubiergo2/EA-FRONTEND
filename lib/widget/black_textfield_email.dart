import 'package:flutter/material.dart';

class BlackTextFieldEmail extends StatelessWidget {
  const BlackTextFieldEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        cursorColor: Color.fromARGB(255, 222, 66, 66),
        style:
            TextStyle(color: Color.fromARGB(255, 239, 239, 239), fontSize: 17),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 222, 66, 66), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          labelText: "Email address",
          labelStyle:
              TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 17),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Color.fromARGB(255, 25, 25, 25),
          filled: true,
        ),
      ),
    );
  }
}
