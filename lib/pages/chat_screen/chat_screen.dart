import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
