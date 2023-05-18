import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//Screens
import 'package:ea_frontend/pages/home_screen/home_screen.dart';
import 'package:ea_frontend/pages/chat_screen/chat_screen.dart';
import 'package:ea_frontend/pages/list_screen/list_screen.dart';
import 'package:ea_frontend/pages/profile_screen/profile_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  //ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

int _currentIndex = 0;

final screens = [
  const HomeScreen(),
  ChatScreen(),
  ListScreen(),
  ProfileScreen(),
];

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 25, 25, 25),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: GNav(
            gap: 10,
            backgroundColor: const Color.fromARGB(255, 25, 25, 25),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 222, 66, 66),
            selectedIndex: _currentIndex,
            onTabChange: (index) => {setState(() => _currentIndex = index)},
            padding: const EdgeInsets.all(10),
            tabs: const [
              GButton(
                icon: Icons.home_filled,
                text: 'Home',
              ),
              GButton(icon: Icons.chat, text: 'Chat'),
              GButton(
                icon: Icons.list,
                text: 'List',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ]),
      ),
      bottomSheet: Container(
        color: const Color.fromARGB(255, 25, 25, 25),
        child: SizedBox(
          height: 1.0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Divider(
              color: Color.fromARGB(255, 41, 41, 41),
              thickness: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
