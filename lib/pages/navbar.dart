import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("pau garcia"),
            accountEmail: Text("paugarcia32@gmail.com"),
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
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: NetworkImage(
                  'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.talent.upc.edu%2Fblog%2Fla-upc-primera-universidad-en-espana-y-top-100-mundial-en-ingenieria-de-telecomunicaciones-electrica-y-electronica%2F&psig=AOvVaw1EziXCYxTpYbWEcCkR5Wh3&ust=1683370206650000&source=images&cd=vfe&ved=0CA4QjRxqFwoTCOjg0-yA3v4CFQAAAAAdAAAAABAH',

                ),
                fit: BoxFit.cover,
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favorites'),
            onTap: () => print('Fav'),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Friends'),
            onTap: () => Navigator.pushNamed(context, '/friends_screen'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () => Navigator.pushNamed(context, '/login_screen'),
          ),
          
        ],
      )
    );
  }
}