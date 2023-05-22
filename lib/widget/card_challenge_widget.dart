// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_map/flutter_map.dart';

import 'maps_widget.dart';

class MyChallengeCard extends StatefulWidget {
  final int index;
  final String attr1;
  final String attr2;
  final String attr3;
  final String lat;
  final String long;
  final PanelController panelController;
  final MapsWidget mapsWidget;

  const MyChallengeCard({
    Key? key,
    required this.index,
    required this.attr1,
    required this.attr2,
    required this.attr3,
    required this.panelController,
    required this.lat,
    required this.long,
    required this.mapsWidget,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyChallengeCardState createState() => _MyChallengeCardState();
}

class _MyChallengeCardState extends State<MyChallengeCard> {
  void tabMap(double latitude, double longitude) {
    widget.mapsWidget.updateView2(41.27561, 2.98722, 200.00);
    // mapsWidget.lat = lat;
    // mapsWidget.long = long;
    // mapsWidget.zoom = 20.0;

    // widget.mapController.move(LatLng(lat, long), mapsWidget.zoom);

    //mapsWidget.mapController.move(LatLng(lat, long), mapsWidget.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                Navigator.pushNamed(context, '/qr_screen');
              },
              backgroundColor: Colors.red,
              icon: Icons.qr_code,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            // tabMap(double.parse(widget.lat), double.parse(widget.long));
            widget.mapsWidget.updateView2(41.27561, 1.98722, 18.00);
            widget.panelController.close();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(30.0, 8, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                  child: ClipOval(
                    child: Text(
                      (widget.index + 1).toString(),
                      style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontSize: 34,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 12, 0),
                  child: Container(
                    width: 1,
                    height: 100,
                    color: const Color.fromARGB(255, 222, 66, 66),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.attr1,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.attr2,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.amber,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.attr3,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
