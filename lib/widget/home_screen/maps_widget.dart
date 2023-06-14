// ignore_for_file: prefer_interpolation_to_compose_strings
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ea_frontend/mobile/home_screen/challenge_screen.dart';

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

  LocationPermission? permission;

  bool serviceEnabled = false;
  bool showUserLocation = false;
  Position? userLocation;

  late MapController mapController;

  @override
  void initState() {
    super.initState();

    mapController = MapController();

    getChallenges();
    getLocationPermission();
  }

  void getChallenges() async {
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

  void getLocationPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Location service disabled',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: const [
                  Text(
                    "The location service is disabled. Please enable it in your device settings.",
                    style: TextStyle(fontSize: 13.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) =>
                        const Color.fromARGB(255, 222, 66, 66).withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) =>
                        const Color.fromARGB(255, 222, 66, 66).withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(
                    color: Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    LocationPermission checkPermissions;
    checkPermissions = await Geolocator.checkPermission();

    if (checkPermissions == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Location permission denied forever',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: const [
                  Text(
                    "Location permission has been denied forever. Please enable it in your device settings to use this feature.",
                    style: TextStyle(fontSize: 13.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) =>
                        const Color.fromARGB(255, 222, 66, 66).withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) =>
                        const Color.fromARGB(255, 222, 66, 66).withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(
                    color: Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }
    listenToLocationUpdates();
  }

  void listenToLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) async {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (mounted) {
        if (serviceEnabled) {
          setState(() {
            userLocation = position;
            showUserLocation = true;
            updateMarkers();
          });
        } else {
          setState(() {
            userLocation = null;
            showUserLocation = false;
            updateMarkers();
          });
        }
      }
    }, onError: (e) {
      setState(() {
        userLocation = null;
        showUserLocation = false;
        updateMarkers();
      });
    });
  }

  void updateMarkers() {
    allmarkers.clear();
    if (showUserLocation && userLocation != null) {
      final userMarker = Marker(
        height: 20,
        width: 20,
        point: LatLng(userLocation!.latitude, userLocation!.longitude),
        builder: (_) => Image.asset(
          'images/gps_pointer.png',
        ),
      );
      allmarkers.add(userMarker);
    }
    fetchAndBuildMarkers();
  }

  void onTapContainer() {
    if (showUserLocation && userLocation != null) {
      final center = LatLng(userLocation!.latitude, userLocation!.longitude);
      mapController.move(center, 18.25);
    } else {
      getLocationPermission();
    }
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
        Positioned(
          bottom: 152.5,
          right: 30.0,
          child: ElevatedButton(
            onPressed: onTapContainer,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: const Color.fromARGB(255, 222, 66, 66),
            ),
            child: Ink(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                showUserLocation
                    ? Icons.gps_fixed_rounded
                    : Icons.gps_off_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
