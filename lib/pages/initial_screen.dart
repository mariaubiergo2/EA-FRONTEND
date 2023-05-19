import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    //en que porcentage de la pantalla se inicia el panel deslizante
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.07;
    //hasta que porcentage de la pantalla lega el panel
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.8;
    return Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: const Text('EETAC -  GO'),
        ),
        body: SlidingUpPanel(
          controller: panelController,
          maxHeight: panelHeightOpen,
          minHeight: panelHeightClosed,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panelBuilder: (controller) => ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: PanelWidget(
              controller: controller,
              panelController: panelController,
            ),
          ),
          collapsed: const Center(child: Text('Challenges')),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          body: const MapsWidget(),
        ));
  }
}
