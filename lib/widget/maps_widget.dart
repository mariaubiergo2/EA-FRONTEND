// ignore_for_file: prefer_interpolation_to_compose_strings, unused_field

// import 'dart:js';

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

class MapsWidget extends StatefulWidget {
  // final LatLng initialPosition;

  const MapsWidget({
    Key? key,
    // required this.initialPosition,
  }) : super(key: key);

  @override
  State<MapsWidget> createState() => _MapsWidgetState();

  void updateView3(double d, double e, double f) {
    final mapState = key as GlobalKey<_MapsWidgetState>?;
    mapState?.currentState?.updateView(d, e, 200.0);
    // (key as GlobalKey<_MapsWidgetState>).currentState?.updateView(d, e, f);
  }
}

class _MapsWidgetState extends State<MapsWidget> {
  List<Marker> allmarkers = [];
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];
  double lat = 41.27561;
  double long = 1.98722;
  double _zoom = 16.0;

  final MapController _mpcontroller = MapController();
  final double _initialZoom = 10.0;
  LatLng _location = LatLng(41.27561, 1.98722);
  final LatLng _initialLocation = LatLng(41.27561, 1.98722);

  late MapController mapController;

  @override
  void initState() {
    super.initState();
    getChallenges();
  }

  Future updateView(double latitude, double longitude, double zooming) async {
    setState(() {
      _location = LatLng(41.27561, 1.98722);
      _zoom = 200.0;
      _mpcontroller.move(_location, 200.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mpcontroller,
      options: MapOptions(
        center: _location,
        zoom: 10.0,
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
        ),
        GestureDetector(
          onTap: () {
            try {
              updateView(41.27561, 1.98722, 200.00);
            } catch (e) {
              print('Problem: $e');
            }
          },
          child: const Text(
            "Mapa",
            style: TextStyle(
                color: Color.fromARGB(255, 222, 66, 66),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
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
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushNamed(context, '/challenge_screen');
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
