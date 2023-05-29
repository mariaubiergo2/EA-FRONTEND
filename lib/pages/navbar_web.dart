import 'package:flutter/material.dart';

double collapsableHeight = 0.0;
Color selected = const Color(0xffffffff);
Color notSelected = const Color(0xafffffff);

class NavBarWeb extends StatefulWidget {
  const NavBarWeb({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarWebState createState() => _NavBarWebState();
}

class _NavBarWebState extends State<NavBarWeb> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('images/wallpaper_web.png'),
                fit: BoxFit.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.25, 5, 50.25, 0),
            child: AnimatedContainer(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Color.fromARGB(255, 25, 25, 25),
              ),
              margin: const EdgeInsets.only(top: 80.0),
              duration: const Duration(milliseconds: 375),
              curve: Curves.ease,
              height: (width < 800.0) ? collapsableHeight : 0.0,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Centrar horizontalmente
                    children: navBarItems,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 25, 25, 25),
                borderRadius: BorderRadius.circular(100),
              ),
              height: 80.0,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    if (width < 800.0) {
                      return NavBarButton(
                        onPressed: () {
                          if (collapsableHeight == 0.0) {
                            setState(() {
                              collapsableHeight = 240.0;
                            });
                          } else if (collapsableHeight == 240.0) {
                            setState(() {
                              collapsableHeight = 0.0;
                            });
                          }
                        },
                      );
                    } else {
                      return Row(
                        children: navBarItems,
                      );
                    }
                  }),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 222, 66, 66),
                        borderRadius: BorderRadius.circular(100)),
                    child: const Center(
                      child: Text(
                        "LOG IN",
                        style: TextStyle(
                          color: Color.fromARGB(255, 242, 242, 242),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarButton extends StatefulWidget {
  final Function onPressed;

  const NavBarButton({
    super.key,
    required this.onPressed,
  });

  @override
  _NavBarButtonState createState() => _NavBarButtonState();
}

class _NavBarButtonState extends State<NavBarButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: InkWell(
          splashColor: Colors.white60,
          onTap: () {
            setState(() {
              widget.onPressed();
            });
          },
          child: const Icon(
            Icons.menu,
            size: 30.0,
            color: Color(0xcfffffff),
          ),
        ),
      ),
    );
  }
}

List<Widget> navBarItems = [
  const NavBarItem(
    text: "HOME",
    route: "/register_screen",
  ),
  const NavBarItem(
    text: "MAP",
    route: "/login_screen",
  ),
  const NavBarItem(
    text: "FAQ",
    route: "",
  ),
];

class NavBarItem extends StatefulWidget {
  final String text;
  final String route;

  const NavBarItem({
    super.key,
    required this.text,
    required this.route,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  Color color = notSelected;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          color = selected;
        });
      },
      onExit: (value) {
        setState(() {
          color = notSelected;
        });
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white60,
          onTap: () {
            Navigator.pushNamed(context, widget.route);
          },
          child: Container(
            height: 60.0,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16.0,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}














































































// import 'package:ea_frontend/pages/home_screen/home_screen_web.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter/material.dart';

// //Screens
// import 'package:ea_frontend/pages/home_screen/home_screen.dart';
// import 'package:ea_frontend/pages/chat_screen/chat_screen.dart';
// import 'package:ea_frontend/pages/profile_screen/profile_screen.dart';
// import 'package:ea_frontend/pages/profile_screen/makefriends_screen.dart';

// class NavBarWeb extends StatefulWidget {
//   const NavBarWeb({Key? key}) : super(key: key);

//   @override
//   _NavBarWebState createState() => _NavBarWebState();
// }

// int _currentIndex = 0;

// final screens = [
//   const HomeScreenWeb(),
//   const HomeScreen(),
//   const MakeFriendsScreen(),
//   const ProfileScreen(),
// ];

// class _NavBarWebState extends State<NavBarWeb> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: screens[_currentIndex],
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                   color: const Color.fromARGB(255, 25, 25, 25),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 17.0, vertical: 15.0),
//                 child: GNav(
//                   gap: 15,
//                   backgroundColor: const Color.fromARGB(255, 25, 25, 25),
//                   color: Colors.white,
//                   activeColor: Colors.white,
//                   tabBackgroundColor: const Color.fromARGB(255, 222, 66, 66),
//                   selectedIndex: _currentIndex,
//                   onTabChange: (index) => setState(() => _currentIndex = index),
//                   padding: const EdgeInsets.fromLTRB(14, 8.5, 14, 8.5),
//                   tabs: const [
//                     GButton(
//                       icon: Icons.home_filled,
//                       iconSize: 25,
//                       text: 'Home',
//                     ),
//                     GButton(
//                       icon: Icons.map_rounded,
//                       iconSize: 22,
//                       text: 'Map',
//                     ),
//                     GButton(
//                       icon: Icons.manage_search_rounded,
//                       iconSize: 27,
//                       text: 'Discover',
//                     ),
//                     GButton(
//                       icon: Icons.person_rounded,
//                       iconSize: 24,
//                       text: 'Profile',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
