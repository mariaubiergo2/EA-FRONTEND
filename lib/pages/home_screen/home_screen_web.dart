import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../widget/maps_widget.dart';
import '../../widget/panel_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:ea_frontend/models/challenge.dart';

void main() async {
  await dotenv.load();
}

class HomeScreenWeb extends StatefulWidget {
  const HomeScreenWeb({Key? key});

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/wallpaper_web.png'),
            fit: BoxFit.none,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1.15, // Ajusta la relación de aspecto de la imagen
                child: Padding(
                  padding:
                      const EdgeInsets.all(25), // Añade márgenes horizontales
                  child: Image.asset(
                    'images/meet_our_app.png',
                    fit: BoxFit
                        .contain, // Ajusta la imagen dentro del espacio disponible
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 15, 25),
                    child: Container(
                      height: 75,
                      width: 1070,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Image.asset('images/google_play.png',
                                    height: 45),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12.5, 0, 0, 0),
                                child: Image.asset('images/app_store.png',
                                    height: 45),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Image.asset('images/twitter.png',
                                      height: 35),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 20, 0),
                                  child: Image.asset('images/reddit.png',
                                      height: 35),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 25, 0),
                                  child: Image.asset('images/discord.png',
                                      height: 40),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
