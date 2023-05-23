// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:dio/dio.dart';

import '../pages/challenge_screen.dart';

void main() async {
  await dotenv.load();
}

class MapScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapsWidget();
}

class MapsWidget extends State<MapScreen> {
  List<Marker> allmarkers = [];
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];

  @override
  void initState() {
    super.initState();
    getChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(41.27561, 1.98722),
        zoom: 16.0,
        maxZoom: 18.0,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: allmarkers,
        )
      ],
    );
  }

  Future getChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/challenge/get/all';
    var response = await Dio().get(path,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));
    var registros = response.data as List;
    for (var sub in registros) {
      challengeList.add(Challenge.fromJson(sub));
    }
    setState(() {
      challengeList = challengeList;
    });
    fetchAndBuildMarkers3();
  }

  Future<void> fetchAndBuildMarkers3() async {
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      final snackBar =
          SnackBar(content: Text("Este reto es: " + challenge.name));
      return Marker(
        point: LatLng(lat, long),
        builder: (context) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Cerrar la pantalla actual
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const MyChallengePage(),
                    ),
                  ),
                );
              },
            );
          },
          child: Image.asset('images/marker.png'),
        ),
      );
    }).toList();

    setState(() {
      allmarkers = newMarkers;
    });
  }

  Future<void> fetchAndBuildMarkers2() async {
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      final snackBar =
          SnackBar(content: Text("Este reto es: " + challenge.name));
      return Marker(
        point: LatLng(lat, long),
        builder: (context) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            showDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(0.5),
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    // Fondo difuminado
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    // Página de desafío
                    MyChallengePage(),
                  ],
                );
              },
            );
          },
          child: Image.asset('images/marker.png'),
        ),
      );
    }).toList();

    setState(() {
      allmarkers = newMarkers;
    });
  }

  Future<void> fetchAndBuildMarkers4() async {
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      final snackBar =
          SnackBar(content: Text("Este reto es: " + challenge.name));
      return Marker(
        point: LatLng(lat, long),
        builder: (context) => GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/challenge_screen',
              arguments: challenge,
            );
          },
          child: Image.asset('images/marker.png'),
        ),
      );
    }).toList();

    setState(() {
      allmarkers = newMarkers;
    });
  }

  Future<void> fetchAndBuildMarkers() async {
    // final challenges = await fetchChallenges();
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      final snackBar =
          SnackBar(content: Text("Este reto es: " + challenge.name));
      return Marker(
        point: LatLng(lat, long),
        builder: (context) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // Navigator.pushNamed(context, '/dialog_helper');
            //DialogHelper.exit(context);
            //Navigator.of(context).pop(false);
          },
          child: Image.asset('images/marker.png'),
        ),
      );
    }).toList();

    setState(() {
      allmarkers = newMarkers;
    });
  }
}
