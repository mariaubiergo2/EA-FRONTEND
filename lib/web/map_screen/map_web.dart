// ignore_for_file: prefer_interpolation_to_compose_strings
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/web/map_screen/pop_up_widget.dart';

void main() async {
  await dotenv.load();
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapsWidget();
}

class MapsWidget extends State<MapScreen> {
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];

  List<Marker> allmarkers = [];

  String? selectedChallengeId;
  String? nameChallenge;
  String? descrChallenge;

  late MapController mapController;

  @override
  void initState() {
    super.initState();

    mapController = MapController();

    getChallenges();
  }

  Future<void> getChallenges() async {
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
    if (mounted) {
      setState(() {
        challengeList = challengeList;
      });
    }
    fetchAndBuildMarkers();
  }

  void fetchAndBuildMarkers() {
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      return Marker(
        height: 35,
        width: 35,
        point: LatLng(lat, long),
        rotate: true,
        builder: (context) => GestureDetector(
          onTap: () {
            setState(() {
              selectedChallengeId = challenge.id;
              nameChallenge = challenge.name;
              descrChallenge = challenge.descr;
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: MyChallengePage(
                        selectedChallengeId: selectedChallengeId,
                        nameChallenge: nameChallenge,
                        descrChallenge: descrChallenge,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Image.asset(
            'images/marker_advanced.png',
          ),
        ),
      );
    }).toList();

    allmarkers.addAll(newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(41.27561, 1.98722),
            zoom: 16.0,
            maxZoom: 18.25,
            maxBounds: LatLngBounds(
              LatLng(41, 1.65),
              LatLng(41.6, 2.35),
            ),
          ),
          nonRotatedChildren: [
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
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
          ],
        ),
      ],
    );
  }
}
