import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/initial_screen.dart';

class MapsWidget extends StatelessWidget {
  const MapsWidget({super.key});

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
          markers: [
            // buildMarker(LatLng(41.27460, 1.98489), "Reto 1"),
            // buildMarker(LatLng(41.27651, 1.98856), "Reto 2"),
            // buildMarker(LatLng(41.27516, 1.98825), "Reto 3")
            Marker(
                point: LatLng(41.27460, 1.98489),
                builder: (content) => GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Image.asset('images/marker.png'),
                    )),
            Marker(
                point: LatLng(41.27651, 1.98856),
                builder: (content) => GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Image.asset('images/marker.png'),
                    )),
            Marker(
                point: LatLng(41.27516, 1.98825),
                builder: (content) => GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Image.asset('images/marker.png'),
                    )),
          ],
        )
      ],
    );
  }
}
