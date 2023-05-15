import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.pushNamed(context, '/login_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 25, 25, 25), // Agregue el color de fondo aquí
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
              child: Column(
                children: [
                  Image.asset(
                    'images/logo_splash.png',
                    height: 250,
                  ),
                ],
              ),
            ),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 222, 66, 66))),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
