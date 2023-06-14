import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//Screens
import 'package:ea_frontend/mobile/home_screen/home_screen.dart';
// import 'package:ea_frontend/pages/chat_screen/chat_screen.dart';
import 'package:ea_frontend/mobile/chat_screen/hub_screen.dart';
import 'package:ea_frontend/mobile/chat_screen/forum_screen.dart';
// import 'package:ea_frontend/pages/chat_screen/prueba_chats.dart';
import 'package:ea_frontend/mobile/chat_screen/chat_screen.dart';
import 'package:ea_frontend/mobile/profile_screen/profile_screen.dart';
import 'package:ea_frontend/mobile/discover_screen/discover_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  //ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

int _currentIndex = 0;

final screens = [
  const HomeScreen(),
  //const HubScreen(),
  // Chat(),
  const MyApp(),
  const DiscoverScreen(),
  const ProfileScreen(),
];

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 22.5),
          content: const Text(
            'Tap back again to leave',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 850),
        ),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: GNav(
            gap: 15,
            backgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).dividerColor,
            activeColor: Color.fromARGB(255, 242, 242, 242),
            tabBackgroundColor: const Color.fromARGB(255, 222, 66, 66),
            selectedIndex: _currentIndex,
            onTabChange: (index) => {setState(() => _currentIndex = index)},
            padding: const EdgeInsets.fromLTRB(14, 8.5, 14, 8.5),
            tabs: [
              GButton(
                icon: Icons.home_filled,
                iconSize: 25,
                // text: 'Home',
                text: AppLocalizations.of(context)!.home,
              ),
              GButton(
                icon: Icons.chat_bubble_rounded,
                iconSize: 22,
                text: AppLocalizations.of(context)!.chat,
              ),
              GButton(
                icon: Icons.manage_search_rounded,
                iconSize: 27,
                // text: 'Discover',
                text: AppLocalizations.of(context)!.discover,
              ),
              GButton(
                icon: Icons.person_rounded,
                iconSize: 24,
                // text: 'Profile',
                text: AppLocalizations.of(context)!.profile,
              ),
            ]),
      ),
      bottomSheet: const Divider(
        color: Color.fromARGB(255, 52, 52, 52),
        height: 0.05,
      ),
    );
  }
}
