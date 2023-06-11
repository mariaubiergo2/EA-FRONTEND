import 'package:ea_frontend/web/profile_screen/profile_web.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//Screens
import 'package:ea_frontend/web/home_screen/home_web.dart';
import 'package:ea_frontend/web/map_screen/map_web.dart';
import 'package:ea_frontend/web/profile_screen/makefriends_mobile.dart';

class NavBarWebDefault extends StatefulWidget {
  const NavBarWebDefault({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavBarWebDefaultState createState() => _NavBarWebDefaultState();
}

int _currentIndex = 0;

final screens = [
  const HomeScreenWeb(),
  const MapScreen(),
  const MakeFriendsScreen(),
  const ProfileScreenWeb(),
];

class _NavBarWebDefaultState extends State<NavBarWebDefault> {
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
                Navigator.pushNamed(context, '/login_web');
              },
              child: Container(
                width: 125,
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
                        Icons.login_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(width: 16.5),
                      Text(
                        'LOG IN',
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
