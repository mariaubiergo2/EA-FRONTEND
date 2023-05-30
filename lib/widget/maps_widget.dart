import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  await dotenv.load();
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapsWidget();
}

class MapsWidget extends State<MapScreen> {
  List<Marker> allmarkers = [];
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];
  bool showUserLocation = false;
  Position? userLocation;

  @override
  void initState() {
    super.initState();
    getChallenges();
    getLocationPermission();
    listenToLocationUpdates();
  }

  Future<void> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  void listenToLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        userLocation = position;
        showUserLocation = true;
        updateMarkers();
      });
    });
  }

  void updateMarkers() {
    allmarkers.clear();
    if (showUserLocation && userLocation != null) {
      final userMarker = Marker(
        rotate: false,
        point: LatLng(userLocation!.latitude, userLocation!.longitude),
        builder: (_) => const Icon(
          Icons.location_searching_rounded,
          color: Color.fromARGB(255, 23, 126, 209),
          size: 20,
        ),
      );
      allmarkers.add(userMarker);
    }
    buildChallengeMarkers();
  }

  void buildChallengeMarkers() {
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      final snackBar =
          SnackBar(content: Text("Este reto es: " + challenge.name));
      return Marker(
        point: LatLng(lat, long),
        rotate: true,
        builder: (context) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Icon(
            Icons.location_pin,
            color: Color.fromARGB(255, 222, 66, 66),
            size: 25,
          ),
        ),
      );
    }).toList();

    allmarkers.addAll(newMarkers);
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
        ),
      ],
    );
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
    setState(() {
      challengeList = challengeList;
    });
    buildChallengeMarkers();
  }
}
