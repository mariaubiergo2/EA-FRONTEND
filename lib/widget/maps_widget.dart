// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:dio/dio.dart';

void main() async {
  await dotenv.load();
}

class MapScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const MapScreen({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<MapScreen> createState() => MapsWidget(mapController: MapController());
}

class MapsWidget extends State<MapScreen> {
  List<Marker> allmarkers = [];
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];
  var lat = 41.27561;
  var long = 1.98722;
  var zoom = 16.0;
  late MapController mapController;

  MapsWidget({required this.mapController});
  LatLng get mapCenter => LatLng(lat, long);

  @override
  void initState() {
    super.initState();
    getChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        //center: LatLng(lat, long),
        center: mapCenter,
        zoom: zoom,
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
    fetchAndBuildMarkers();
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
