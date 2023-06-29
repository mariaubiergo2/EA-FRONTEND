// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../widgets/home_screen/maps_widget.dart';
import '../../widgets/home_screen/panel_widget.dart';

void main() async {
  await dotenv.load();
}

class HomeScreen extends StatefulWidget {
  //const LoginScreen({super.key, required String title});
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final panelController = PanelController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //en que porcentage de la pantalla se inicia el panel deslizante
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.055;
    //hasta que porcentage de la pantalla lega el panel
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.78;
    return Scaffold(
        body: SlidingUpPanel(
      backdropOpacity: 0.5,
      controller: panelController,
      maxHeight: panelHeightOpen,
      minHeight: panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      backdropEnabled: true,
      panelBuilder: (controller) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: PanelWidget(
          controller: controller,
          panelController: panelController,
        ),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      body: MapScreen(),
    ));
  }
}
