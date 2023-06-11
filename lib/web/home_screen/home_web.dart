import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
}

class HomeScreenWeb extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
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
                aspectRatio: 1.20, // Ajusta la relación de aspecto de la imagen
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
                    padding: const EdgeInsets.fromLTRB(35, 0, 35, 37.5),
                    child: Container(
                      height: 87.5,
                      width: 1080,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  const url = 'https://play.google.com/store';
                                  // ignore: deprecated_member_use
                                  if (await canLaunch(url)) {
                                    // ignore: deprecated_member_use
                                    await launch(url);
                                  } else {
                                    throw 'No se pudo abrir el enlace $url';
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20.5, 0, 0, 0),
                                  child: Image.asset('images/google_play.png',
                                      height: 47.5),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  const url =
                                      'https://www.apple.com/app-store/';
                                  // ignore: deprecated_member_use
                                  if (await canLaunch(url)) {
                                    // ignore: deprecated_member_use
                                    await launch(url);
                                  } else {
                                    throw 'No se pudo abrir el enlace $url';
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(17, 0, 0, 0),
                                  child: Image.asset('images/app_store.png',
                                      height: 47.5),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    const url = 'https://www.youtube.com/';
                                    // ignore: deprecated_member_use
                                    if (await canLaunch(url)) {
                                      // ignore: deprecated_member_use
                                      await launch(url);
                                    } else {
                                      throw 'No se pudo abrir el enlace $url';
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 30, 0),
                                    child: Image.asset('images/youtube.png',
                                        height: 25.5),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    const url = 'https://twitter.com/Grup4Ea/';
                                    // ignore: deprecated_member_use
                                    if (await canLaunch(url)) {
                                      // ignore: deprecated_member_use
                                      await launch(url);
                                    } else {
                                      throw 'No se pudo abrir el enlace $url';
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 25, 0),
                                    child: Image.asset('images/twitter.png',
                                        height: 33),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    const url = 'https://www.reddit.com/';
                                    // ignore: deprecated_member_use
                                    if (await canLaunch(url)) {
                                      // ignore: deprecated_member_use
                                      await launch(url);
                                    } else {
                                      throw 'No se pudo abrir el enlace $url';
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 25, 0),
                                    child: Image.asset('images/reddit.png',
                                        height: 33),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    const url = 'https://discord.com/';
                                    // ignore: deprecated_member_use
                                    if (await canLaunch(url)) {
                                      // ignore: deprecated_member_use
                                      await launch(url);
                                    } else {
                                      throw 'No se pudo abrir el enlace $url';
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 35, 0),
                                    child: Image.asset('images/discord.png',
                                        height: 38),
                                  ),
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
