import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    getChallenges();
    getLocationPermission();
  }

  Future<void> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

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
                  'OK',
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
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
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
                  openAppSettings(); // Abre la configuración de la aplicación
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

    buildChallengeMarkers();
    listenToLocationUpdates();
  }

  void listenToLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        userLocation = position;
        showUserLocation = true;
        updateMarkers();
      });
    }, onError: (e) {
      setState(() {
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
    buildChallengeMarkers();
  }

  void buildChallengeMarkers() {
    final newMarkers = challengeList.map((challenge) {
      final lat = double.parse(challenge.lat);
      final long = double.parse(challenge.long);
      final snackBar =
          SnackBar(content: Text("Este reto es: ${challenge.name}"));
      return Marker(
        height: 35,
        width: 35,
        point: LatLng(lat, long),
        rotate: true,
        builder: (context) => GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            maxZoom: 18.0,
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
          bottom: 145.0,
          right: 25.0,
          child: GestureDetector(
            onTap: onTapContainer,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 222, 66, 66),
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

  void onTapContainer() {
    if (showUserLocation && userLocation != null) {
      final center = LatLng(userLocation!.latitude, userLocation!.longitude);
      mapController.move(center, 16.0);
    } else {
      getLocationPermission();
    }
  }
}
