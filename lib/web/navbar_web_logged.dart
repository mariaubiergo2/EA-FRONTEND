import 'package:ea_frontend/web/profile_screen/profile_web.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//Screens
import 'package:ea_frontend/web/home_screen/home_web.dart';
import 'package:ea_frontend/web/map_screen/map_web.dart';
import 'package:ea_frontend/web/profile_screen/makefriends_mobile.dart';

class NavBarWebLogged extends StatefulWidget {
  const NavBarWebLogged({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavBarWebLoggedState createState() => _NavBarWebLoggedState();
}

int _currentIndex = 0;

final screens = [
  const HomeScreenWeb(),
  const MapScreen(),
  const MakeFriendsScreen(),
  const ProfileScreenWeb(),
];
void onTapContainer() {
  // Lógica para manejar el evento de pulsación del botón
}

class _NavBarWebLoggedState extends State<NavBarWebLogged> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: screens[_currentIndex],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35, 35, 35, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 25, 25, 25),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 22.0, vertical: 20.0),
                child: GNav(
                  gap: 15,
                  backgroundColor: const Color.fromARGB(255, 25, 25, 25),
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: const Color.fromARGB(255, 222, 66, 66),
                  selectedIndex: _currentIndex,
                  mainAxisAlignment: MainAxisAlignment.start,
                  onTabChange: (index) => setState(() => _currentIndex = index),
                  padding: const EdgeInsets.fromLTRB(14, 8.5, 14, 8.5),
                  tabs: const [
                    GButton(
                      icon: Icons.home_filled,
                      iconSize: 25,
                      text: 'Home',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.map_rounded,
                      iconSize: 25,
                      text: 'Map',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.manage_search_rounded,
                      iconSize: 32,
                      text: 'Discover',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.chat_bubble_rounded,
                      iconSize: 26,
                      text: 'Chat',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.photo_album_rounded,
                      iconSize: 27,
                      text: 'Gallery',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.people_alt_rounded,
                      iconSize: 27,
                      text: 'Team',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.contact_mail_rounded,
                      iconSize: 27,
                      text: 'Contact',
                    ),
                    GButton(
                      margin: EdgeInsets.only(left: 15),
                      icon: Icons.info_rounded,
                      iconSize: 27,
                      text: 'About',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 57,
            right: 57.5,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile_web');
              },
              child: Container(
                width: 137.5,
                height: 41,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 222, 66, 66),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.5),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(width: 16.5),
                      Text(
                        'PROFILE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
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
    );
  }
}
