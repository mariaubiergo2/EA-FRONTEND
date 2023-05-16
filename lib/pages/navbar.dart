import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  // Algunos datos de ejemplo
  String? _idUser = "";
  String? _name = "";
  String? _surname = "";
  String? _username = "";
  String? _token = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _idUser = prefs.getString('idUser');
      _name = prefs.getString('name');
      _surname = prefs.getString('surname');
      _username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('$_name $_surname'),
          accountEmail: Text(_username.toString()),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.network(
                'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage(
                  'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.talent.upc.edu%2Fblog%2Fla-upc-primera-universidad-en-espana-y-top-100-mundial-en-ingenieria-de-telecomunicaciones-electrica-y-electronica%2F&psig=AOvVaw1EziXCYxTpYbWEcCkR5Wh3&ust=1683370206650000&source=images&cd=vfe&ved=0CA4QjRxqFwoTCOjg0-yA3v4CFQAAAAAdAAAAABAH',
                ),
                fit: BoxFit.cover,
              )),
        ),
        const ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favorites'),
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Friends'),
          onTap: () => Navigator.pushNamed(context, '/friends_screen'),
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Log Out'),
          onTap: () => Navigator.pushNamed(context, '/login_screen'),
        ),
      ],
    ));
  }
}
