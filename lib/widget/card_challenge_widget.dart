import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_map/flutter_map.dart';

class MyChallengeCard extends StatelessWidget {
  final int index;
  final String attr1;
  final String attr2;
  final String attr3;
  final String lat;
  final String long;
  late MapController mapController;
  //final ScrollController controller;
  final PanelController panelController;

//  mapController.move(LatLng(double.parse(lat), double.parse(long)), 20);

  MyChallengeCard({
    Key? key,
    required this.index,
    required this.attr1,
    required this.attr2,
    required this.attr3,
    required this.panelController,
    required this.lat,
    required this.long,
  }) : super(key: key) {
    mapController = MapController(); // Inicializa el mapController
  }

  Widget tabMap(BuildContext context) {
    final double latitude = double.parse(lat);
    final double longitude = double.parse(long);

    return FlutterMap(
        options: MapOptions(
      center: LatLng(latitude, longitude),
      zoom: 20,
    ));
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
              panelController.close();
              //panelController.animatePanelToPosition(0);
              tabMap(context);
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
                        (index + 1).toString(),
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
                          attr1,
                          style: const TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          attr2,
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
                          attr3,
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
        ));
  }
}
