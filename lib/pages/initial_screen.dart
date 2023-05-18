// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widget/maps_widget.dart';
import '../widget/panel_widget.dart';
import 'package:ea_frontend/pages/navbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import 'package:ea_frontend/models/challenge.dart';
import 'package:ea_frontend/widget/card_widget.dart';

class InitialScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

const snackBar = SnackBar(
  content: Text('Marker Clicked'),
);

class _InitialScreenState extends State<InitialScreen> {
  final panelController = PanelController();
  List<Marker> allmarkers = [];
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];

  @override
  void initState() {
    super.initState();
    getChallenges();
  }

  Future getChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://127.0.0.1:3002/challenge/get/all';
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
    for (int i = 0; i < challengeList.length; i++) {
      print(challengeList[i]);
    }
    fetchAndBuildMarkers();
  }

  Future<void> fetchAndBuildMarkers() async {
    // final challenges = await fetchChallenges();
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
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
    for (int i = 0; i < allmarkers.length; i++) {
      print(allmarkers[i].point.latitude);
      print(allmarkers[i].point.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    //en que porcentage de la pantalla se inicia el panel deslizante
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.07;
    //hasta que porcentage de la pantalla lega el panel
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: const Text('EETAC -  GO'),
        ),
        body: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SlidingUpPanel(
            controller: panelController,
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: FlutterMap(
              options: MapOptions(
                center: LatLng(41.27561, 1.98722),
                zoom: 16.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: allmarkers,

                  // buildMarker(LatLng(41.27460, 1.98489), "Reto 1"),
                  // buildMarker(LatLng(41.27651, 1.98856), "Reto 2"),
                  // buildMarker(LatLng(41.27516, 1.98825), "Reto 3")
                  // Marker(
                  //     point: LatLng(41.27460, 1.98489),
                  //     builder: (content) => GestureDetector(
                  //           onTap: () {
                  //             ScaffoldMessenger.of(context)
                  //                 .showSnackBar(snackBar);
                  //           },
                  //           child: Image.asset('images/marker.png'),
                  //         )),
                  // Marker(
                  //     point: LatLng(41.27651, 1.98856),
                  //     builder: (content) => GestureDetector(
                  //           onTap: () {
                  //             ScaffoldMessenger.of(context)
                  //                 .showSnackBar(snackBar);
                  //           },
                  //           child: Image.asset('images/marker.png'),
                  //         )),
                  // Marker(
                  //     point: LatLng(41.27516, 1.98825),
                  //     builder: (content) => GestureDetector(
                  //           onTap: () {
                  //             ScaffoldMessenger.of(context)
                  //                 .showSnackBar(snackBar);
                  //           },
                  //           child: Image.asset('images/marker.png'),
                  //         )),
                )
              ],
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            ),
            panelBuilder: (controller) => PanelWidget(
              controller: controller,
              panelController: panelController,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          )
        ]));
  }
}
