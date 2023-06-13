import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/challenge.dart';

class MyChallengePage extends StatefulWidget {
  final String? selectedChallengeId;
  final String? nameChallenge;
  final String? descrChallenge;
  const MyChallengePage(
      {Key? key,
      this.selectedChallengeId,
      this.nameChallenge,
      this.descrChallenge})
      : super(key: key);

  @override
  State<MyChallengePage> createState() => _MyChallengePageState();
}

class _MyChallengePageState extends State<MyChallengePage> {
  Challenge? challenge;
  String? _token = "";
  String? _idChallenge = "";
  String? _name = "";
  String? _descr = "";
  String? _exp = "";
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    getChallengeInfo().then((_) {
      callApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  Future<void> getChallengeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _idChallenge = widget.selectedChallengeId;
      _name = widget.nameChallenge;
      _descr = widget.descrChallenge;
      _exp = prefs.getString('exp');
    });
  }

  Future<void> callApi() async {
    String path =
        'http://${dotenv.env['API_URL']}/challenge/get/${widget.selectedChallengeId}';
    print(path);
    var response = await Dio().get(
      path,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_token",
        },
      ),
    );
    var challengeData = response.data;
    var challenge = Challenge.fromJson(challengeData);
    setState(() {
      this.challenge = challenge;
    });
  }

  Widget _buildChild(BuildContext context) {
    if (challenge == null) {
      // Muestra un indicador de carga mientras se obtiene la información del desafío
      return const CircularProgressIndicator();
    } else {
      // Muestra la información del desafío
      return Container(
        height: 350,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 25, 25, 25),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'images/marker_advanced.png',
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _name ?? '',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _descr ?? '',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 8),
                if (isButtonPressed)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isButtonPressed = true;
                      });
                      Navigator.pushNamed(context, '/qr_screen');
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
