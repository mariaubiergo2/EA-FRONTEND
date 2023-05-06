import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widget/maps_widget.dart';
import '../widget/panel_widget.dart';
import 'package:ea_frontend/pages/navbar.dart';

class InitialScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

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
        body: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SlidingUpPanel(
            controller: panelController,
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: const MapsWidget(),
            panelBuilder: (controller) => PanelWidget(
              controller: controller,
              panelController: panelController,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          )
        ]));
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 130, 164, 51),
      body: Center(
        child: 
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/login_screen');
            },
          ),
      ),
    );
  }*/
}
