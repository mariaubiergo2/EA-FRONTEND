import 'package:flutter/material.dart';
import 'package:ea_frontend/pages/login_screen.dart';

class SplashScreen extends StatefulWidget{
  //const Splash({ Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }

  _navigatetohome()async{
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushNamed(context, '/login_screen');
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('images/logoApp.png'),
              ),
          Center(
            child: Text('Welcome to EETACgo!',
              style: TextStyle(fontFamily: 'NerkoOne', fontSize: 40.0)
          )),
          Spacer(),
          CircularProgressIndicator(),
          Spacer(),
        ],
      )
    );
  }
}